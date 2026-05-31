# This is the vendored build script from
# https://raw.githubusercontent.com/NixOS/nix/refs/heads/master/docker.nix
# which builds the Nix image.
# This is only here to please Hydra which is not beeing able to build IFDs.
# `import (nixRepo + "./docker.nix")`.
{
  # Core dependencies
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  dockerTools ? pkgs.dockerTools,
  runCommand ? pkgs.runCommand,
  buildPackages ? pkgs.buildPackages,
  # Image configuration
  name ? "nix",
  tag ? "latest",
  bundleNixpkgs ? true,
  channelName ? "nixpkgs",
  channelURL ? "https://channels.nixos.org/nixpkgs-unstable",
  extraPkgs ? [ ],
  maxLayers ? 70,
  nixConf ? { },
  flake-registry ? null,
  uid ? 0,
  gid ? 0,
  uname ? "root",
  gname ? "root",
  Labels ? {
    "org.opencontainers.image.title" = "Nix";
    "org.opencontainers.image.source" = "https://github.com/NixOS/nix";
    "org.opencontainers.image.vendor" = "Nix project";
    "org.opencontainers.image.version" = nix.version;
    "org.opencontainers.image.description" = "Nix container image";
  },
  Cmd ? [ (lib.getExe bashInteractive) ],
  # Default Packages
  nix ? pkgs.nix,
  bashInteractive ? pkgs.bashInteractive,
  coreutils-full ? pkgs.coreutils-full,
  gnutar ? pkgs.gnutar,
  gzip ? pkgs.gzip,
  gnugrep ? pkgs.gnugrep,
  which ? pkgs.which,
  curl ? pkgs.curl,
  less ? pkgs.less,
  wget ? pkgs.wget,
  man ? pkgs.man,
  cacert ? pkgs.cacert,
  findutils ? pkgs.findutils,
  iana-etc ? pkgs.iana-etc,
  gitMinimal ? pkgs.gitMinimal,
  openssh ? pkgs.openssh,
  # Other dependencies
  shadow ? pkgs.shadow,
}:
let
  defaultPkgs = [
    nix
    bashInteractive
    coreutils-full
    gnutar
    gzip
    gnugrep
    which
    curl
    less
    wget
    man
    cacert.out
    findutils
    iana-etc
    gitMinimal
    openssh
  ]
  ++ extraPkgs;

  users = {

    root = {
      uid = 0;
      shell = lib.getExe bashInteractive;
      home = "/root";
      gid = 0;
      groups = [ "root" ];
      description = "System administrator";
    };

    nobody = {
      uid = 65534;
      shell = lib.getExe' shadow "nologin";
      home = "/var/empty";
      gid = 65534;
      groups = [ "nobody" ];
      description = "Unprivileged account (don't use!)";
    };

  }
  // lib.optionalAttrs (uid != 0) {
    "${uname}" = {
      uid = uid;
      shell = lib.getExe bashInteractive;
      home = "/home/${uname}";
      gid = gid;
      groups = [ "${gname}" ];
      description = "Nix user";
    };
  }
  // lib.listToAttrs (
    map (n: {
      name = "nixbld${toString n}";
      value = {
        uid = 30000 + n;
        gid = 30000;
        groups = [ "nixbld" ];
        description = "Nix build user ${toString n}";
      };
    }) (lib.lists.range 1 32)
  );

  groups = {
    root.gid = 0;
    nixbld.gid = 30000;
    nobody.gid = 65534;
  }
  // lib.optionalAttrs (gid != 0) {
    "${gname}".gid = gid;
  };

  userToPasswd = (
    k:
    {
      uid,
      gid ? 65534,
      home ? "/var/empty",
      description ? "",
      shell ? "/bin/false",
      groups ? [ ],
    }:
    "${k}:x:${toString uid}:${toString gid}:${description}:${home}:${shell}"
  );
  passwdContents = (lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs userToPasswd users)));

  userToShadow = k: { ... }: "${k}:!:1::::::";
  shadowContents = (lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs userToShadow users)));

  # Map groups to members
  # {
  #   group = [ "user1" "user2" ];
  # }
  groupMemberMap = (
    let
      # Create a flat list of user/group mappings
      mappings = (
        builtins.foldl' (
          acc: user:
          let
            groups = users.${user}.groups or [ ];
          in
          acc
          ++ map (group: {
            inherit user group;
          }) groups
        ) [ ] (lib.attrNames users)
      );
    in
    (builtins.foldl' (
      acc: v:
      acc
      // {
        ${v.group} = acc.${v.group} or [ ] ++ [ v.user ];
      }
    ) { } mappings)
  );

  groupToGroup =
    k:
    { gid }:
    let
      members = groupMemberMap.${k} or [ ];
    in
    "${k}:x:${toString gid}:${lib.concatStringsSep "," members}";
  groupContents = (lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs groupToGroup groups)));

  toConf =
    with pkgs.lib.generators;
    toKeyValue {
      mkKeyValue = mkKeyValueDefault {
        mkValueString = v: if lib.isList v then lib.concatStringsSep " " v else mkValueStringDefault { } v;
      } " = ";
    };

  nixConfContents = toConf (
    {
      sandbox = false;
      build-users-group = "nixbld";
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    }
    // nixConf
  );

  userHome = if uid == 0 then "/root" else "/home/${uname}";

  baseSystem =
    let
      nixpkgs = pkgs.path;
      channel = runCommand "channel-nixos" { inherit bundleNixpkgs; } ''
        mkdir $out
        if [ "$bundleNixpkgs" ]; then
          ln -s ${
            builtins.path {
              path = nixpkgs;
              name = "source";
            }
          } $out/nixpkgs
          echo "[]" > $out/manifest.nix
        fi
      '';
      # doc/manual/source/command-ref/files/manifest.nix.md
      manifest = buildPackages.runCommand "manifest.nix" { } ''
        cat > $out <<EOF
        [
        ${lib.concatStringsSep "\n" (
          map (
            drv:
            let
              outputs = drv.outputsToInstall or [ "out" ];
            in
            ''
              {
                ${lib.concatStringsSep "\n" (
                  map (output: ''
                    ${output} = { outPath = "${lib.getOutput output drv}"; };
                  '') outputs
                )}
                outputs = [ ${lib.concatStringsSep " " (map (x: "\"${x}\"") outputs)} ];
                name = "${drv.name}";
                outPath = "${drv}";
                system = "${drv.system}";
                type = "derivation";
                meta = { };
              }
            ''
          ) defaultPkgs
        )}
        ]
        EOF
      '';
      profile = buildPackages.buildEnv {
        name = "root-profile-env";
        paths = defaultPkgs;

        postBuild = ''
          mv $out/manifest $out/manifest.nix
        '';
        inherit manifest;
      };
      flake-registry-path =
        if (flake-registry == null) then
          null
        else if (builtins.readFileType (toString flake-registry)) == "directory" then
          "${flake-registry}/flake-registry.json"
        else
          flake-registry;
    in
    runCommand "base-system"
      {
        inherit
          passwdContents
          groupContents
          shadowContents
          nixConfContents
          ;
        passAsFile = [
          "passwdContents"
          "groupContents"
          "shadowContents"
          "nixConfContents"
        ];
        allowSubstitutes = false;
        preferLocalBuild = true;
      }
      (
        ''
          env
          set -x
          mkdir -p $out/etc

          # may get replaced by pkgs.dockerTools.caCertificates
          mkdir -p $out/etc/ssl/certs
          # Old NixOS compatibility.
          ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs
          # NixOS canonical location
          ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-certificates.crt

          cat $passwdContentsPath > $out/etc/passwd
          echo "" >> $out/etc/passwd

          cat $groupContentsPath > $out/etc/group
          echo "" >> $out/etc/group

          cat $shadowContentsPath > $out/etc/shadow
          echo "" >> $out/etc/shadow

          mkdir -p $out/usr
          ln -s /nix/var/nix/profiles/share $out/usr/

          mkdir -p $out/nix/var/nix/gcroots

          mkdir $out/tmp

          mkdir -p $out/var/tmp

          mkdir -p $out/etc/nix
          cat $nixConfContentsPath > $out/etc/nix/nix.conf

          mkdir -p $out${userHome}
          mkdir -p $out/nix/var/nix/profiles/per-user/${uname}

          # see doc/manual/source/command-ref/files/profiles.md
          ln -s ${profile} $out/nix/var/nix/profiles/default-1-link
          ln -s /nix/var/nix/profiles/default-1-link $out/nix/var/nix/profiles/default
          ln -s /nix/var/nix/profiles/default $out${userHome}/.nix-profile

          # see doc/manual/source/command-ref/files/channels.md
          ln -s ${channel} $out/nix/var/nix/profiles/per-user/${uname}/channels-1-link
          ln -s /nix/var/nix/profiles/per-user/${uname}/channels-1-link $out/nix/var/nix/profiles/per-user/${uname}/channels

          # see doc/manual/source/command-ref/files/default-nix-expression.md
          mkdir -p $out${userHome}/.nix-defexpr
          ln -s /nix/var/nix/profiles/per-user/${uname}/channels $out${userHome}/.nix-defexpr/channels
          echo "${channelURL} ${channelName}" > $out${userHome}/.nix-channels

          # may get replaced by pkgs.dockerTools.binSh & pkgs.dockerTools.usrBinEnv
          mkdir -p $out/bin $out/usr/bin
          ln -s ${lib.getExe' coreutils-full "env"} $out/usr/bin/env
          ln -s ${lib.getExe bashInteractive} $out/bin/sh

        ''
        + (lib.optionalString (flake-registry-path != null) ''
          nixCacheDir="${userHome}/.cache/nix"
          mkdir -p $out$nixCacheDir
          globalFlakeRegistryPath="$nixCacheDir/flake-registry.json"
          ln -s ${flake-registry-path} $out$globalFlakeRegistryPath
          mkdir -p $out/nix/var/nix/gcroots/auto
          rootName=$(${lib.getExe' nix "nix"} --extra-experimental-features nix-command hash file --type sha1 --base32 <(echo -n $globalFlakeRegistryPath))
          ln -s $globalFlakeRegistryPath $out/nix/var/nix/gcroots/auto/$rootName
        '')
      );

in
dockerTools.buildLayeredImageWithNixDb {

  inherit
    name
    tag
    maxLayers
    uid
    gid
    uname
    gname
    ;

  contents = [ baseSystem ];

  extraCommands = ''
    rm -rf nix-support
    ln -s /nix/var/nix/profiles nix/var/nix/gcroots/profiles
  '';
  fakeRootCommands = ''
    chmod 1777 tmp
    chmod 1777 var/tmp
    chown -R ${toString uid}:${toString gid} .${userHome}
    chown -R ${toString uid}:${toString gid} nix
  '';

  config = {
    inherit Cmd Labels;
    User = "${toString uid}:${toString gid}";
    Env = [
      "USER=${uname}"
      "PATH=${
        lib.concatStringsSep ":" [
          "${userHome}/.nix-profile/bin"
          "/nix/var/nix/profiles/default/bin"
          "/nix/var/nix/profiles/default/sbin"
        ]
      }"
      "MANPATH=${
        lib.concatStringsSep ":" [
          "${userHome}/.nix-profile/share/man"
          "/nix/var/nix/profiles/default/share/man"
        ]
      }"
      "SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
      "GIT_SSL_CAINFO=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
      "NIX_PATH=/nix/var/nix/profiles/per-user/${uname}/channels:${userHome}/.nix-defexpr/channels"
    ];
  };

}

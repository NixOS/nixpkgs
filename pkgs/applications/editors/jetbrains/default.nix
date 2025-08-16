let
  # `ides.json` is handwritten and contains information that doesn't change across updates, like maintainers and other metadata
  # `versions.json` contains everything generated/needed by the update script version numbers, build numbers and tarball hashes
  ideInfo = builtins.fromJSON (builtins.readFile ./bin/ides.json);
  versions = builtins.fromJSON (builtins.readFile ./bin/versions.json);
in
{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  buildFHSEnv,
  jdk,
  zlib,
  python3,
  lldb,
  dotnetCorePackages,
  maven,
  openssl,
  expat,
  libxcrypt,
  libxcrypt-legacy,
  fontconfig,
  libxml2,
  runCommand,
  musl,
  R,
  libgcc,
  lttng-ust_2_12,
  xz,
  xorg,
  libGL,
  libICE,
  libSM,
  libX11,
  vmopts ? null,
  forceWayland ? false,
}:
let
  inherit (stdenv.hostPlatform) system;

  products = versions.${system} or (throw "Unsupported system: ${system}");

  dotnet-sdk = dotnetCorePackages.sdk_8_0-source;

  package = if stdenv.hostPlatform.isDarwin then ./bin/darwin.nix else ./bin/linux.nix;
  mkJetBrainsProductCore = callPackage package { inherit vmopts; };
  mkMeta = meta: fromSource: {
    inherit (meta) homepage longDescription;
    description =
      meta.description
      + lib.optionalString meta.isOpenSource (
        if fromSource then " (built from source)" else " (patched binaries from jetbrains)"
      );
    maintainers = map (x: lib.maintainers."${x}") meta.maintainers;
    teams = [ lib.teams.jetbrains ];
    license = if meta.isOpenSource then lib.licenses.asl20 else lib.licenses.unfree;
    sourceProvenance =
      if fromSource then
        [ lib.sourceTypes.fromSource ]
      else
        (
          if stdenv.hostPlatform.isDarwin then
            [ lib.sourceTypes.binaryNativeCode ]
          else
            [ lib.sourceTypes.binaryBytecode ]
        );
  };

  mkJetBrainsProduct =
    {
      pname,
      fromSource ? false,
      extraWrapperArgs ? [ ],
      extraLdPath ? [ ],
      extraBuildInputs ? [ ],
      extraTests ? { },
    }:
    let
      basePackage = mkJetBrainsProductCore {
        inherit
          pname
          extraLdPath
          jdk
          ;
        extraBuildInputs =
          extraBuildInputs
          ++ [ stdenv.cc.cc ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            fontconfig
            libGL
            libX11
          ];
        extraWrapperArgs =
          extraWrapperArgs
          ++ lib.optionals (stdenv.hostPlatform.isLinux && forceWayland) [
            ''--add-flags "\''${WAYLAND_DISPLAY:+-Dawt.toolkit.name=WLToolkit}"''
          ];
        src =
          if fromSource then
            communitySources."${pname}"
          else
            fetchurl {
              url = products."${pname}".url;
              sha256 = products."${pname}".sha256;
            };
        version = if fromSource then communitySources."${pname}".version else products."${pname}".version;
        buildNumber =
          if fromSource then communitySources."${pname}".buildNumber else products."${pname}".build_number;
        inherit (ideInfo."${pname}") wmClass product;
        productShort = ideInfo."${pname}".productShort or ideInfo."${pname}".product;
        meta = mkMeta ideInfo."${pname}".meta fromSource;
        passthru.tests = extraTests // {
          plugins = callPackage ./plugins/tests.nix { ideName = pname; };
        };
        libdbm =
          if ideInfo."${pname}".meta.isOpenSource then
            communitySources."${pname}".libdbm
          else
            communitySources.idea-community.libdbm;
        fsnotifier =
          if ideInfo."${pname}".meta.isOpenSource then
            communitySources."${pname}".fsnotifier
          else
            communitySources.idea-community.fsnotifier;
      };
    in
    # Add FHS support using overrideAttrs (Linux only)
    basePackage.overrideAttrs (
      finalAttrs: oldAttrs: {
        passthru =
          oldAttrs.passthru
          // lib.optionalAttrs stdenv.hostPlatform.isLinux (
            let
              fhsEnv = callPackage ./fhs-env.nix { inherit buildFHSEnv; };
            in
            {
              fhs = fhsEnv {
                product = finalAttrs.finalPackage;
                pname = basePackage.pname;
                version = basePackage.version;
                meta = basePackage.meta;
                executableName = basePackage.pname;
              };
              fhsWithPackages =
                f:
                fhsEnv {
                  product = finalAttrs.finalPackage;
                  pname = basePackage.pname;
                  version = basePackage.version;
                  meta = basePackage.meta;
                  executableName = basePackage.pname;
                  extraTargetPkgs = f;
                };
            }
          );
      }
    );

  communitySources = callPackage ./source { };

  buildIdea =
    args:
    mkJetBrainsProduct (
      args
      // {
        extraLdPath = [ zlib ];
        extraWrapperArgs = [
          ''--set M2_HOME "${maven}/maven"''
          ''--set M2 "${maven}/maven/bin"''
        ];
      }
    );

  buildPycharm =
    args:
    (mkJetBrainsProduct args).overrideAttrs (
      finalAttrs: previousAttrs:
      lib.optionalAttrs stdenv.hostPlatform.isLinux {
        buildInputs =
          with python3.pkgs;
          (previousAttrs.buildInputs or [ ])
          ++ [
            python3
            setuptools
          ];
        preInstall = ''
          echo "compiling cython debug speedups"
          if [[ -d plugins/python-ce ]]; then
              ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
          else
              ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
          fi
        '';
        # See https://www.jetbrains.com/help/pycharm/2022.1/cython-speedups.html
      }
    );

  patchSharedLibs = lib.optionalString stdenv.hostPlatform.isLinux ''
    ls -d \
      $out/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/bin/*/linux/*/lib/python3.8/lib-dynload/* \
      $out/*/plugins/*/bin/*/linux/*/lib/liblldb.so \
      $out/*/plugins/*/bin/*/linux/*/lib/python3.8/lib-dynload/* |
    xargs patchelf \
      --replace-needed libssl.so.10 libssl.so \
      --replace-needed libcrypto.so.10 libcrypto.so \
      --replace-needed libcrypt.so.1 libcrypt.so \
      ${lib.optionalString stdenv.hostPlatform.isAarch "--replace-needed libxml2.so.2 libxml2.so"}
  '';
in
rec {
  # Sorted alphabetically

  aqua = mkJetBrainsProduct {
    pname = "aqua";
    extraBuildInputs = [
      lldb
    ];
  };
  aqua-fhs = if stdenv.hostPlatform.isLinux then aqua.fhs else null;
  aqua-fhsWithPackages = if stdenv.hostPlatform.isLinux then aqua.fhsWithPackages else null;

  clion =
    (mkJetBrainsProduct {
      pname = "clion";
      extraBuildInputs =
        lib.optionals stdenv.hostPlatform.isLinux [
          python3
          openssl
          libxcrypt-legacy
          lttng-ust_2_12
          musl
        ]
        ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
          expat
          libxml2
          xz
        ];
    }).overrideAttrs
      (attrs: {
        postInstall =
          (attrs.postInstall or "")
          + lib.optionalString stdenv.hostPlatform.isLinux ''
            for dir in $out/clion/plugins/clion-radler/DotFiles/linux-*; do
              rm -rf $dir/dotnet
              ln -s ${dotnet-sdk}/share/dotnet $dir/dotnet
            done
          '';

        postFixup = ''
          ${attrs.postFixup or ""}
          ${patchSharedLibs}
        '';
      });
  clion-fhs = if stdenv.hostPlatform.isLinux then clion.fhs else null;
  clion-fhsWithPackages = if stdenv.hostPlatform.isLinux then clion.fhsWithPackages else null;

  datagrip = mkJetBrainsProduct {
    pname = "datagrip";
  };
  datagrip-fhs = if stdenv.hostPlatform.isLinux then datagrip.fhs else null;
  datagrip-fhsWithPackages = if stdenv.hostPlatform.isLinux then datagrip.fhsWithPackages else null;

  dataspell =
    let
      libr = runCommand "libR" { } ''
        mkdir -p $out/lib
        ln -s ${R}/lib/R/lib/libR.so $out/lib/libR.so
      '';
    in
    mkJetBrainsProduct {
      pname = "dataspell";
      extraBuildInputs = [
        libgcc
        libr
      ];
    };
  dataspell-fhs = if stdenv.hostPlatform.isLinux then dataspell.fhs else null;
  dataspell-fhsWithPackages = if stdenv.hostPlatform.isLinux then dataspell.fhsWithPackages else null;

  gateway = mkJetBrainsProduct {
    pname = "gateway";
    extraBuildInputs = [ libgcc ];
  };
  gateway-fhs = if stdenv.hostPlatform.isLinux then gateway.fhs else null;
  gateway-fhsWithPackages = if stdenv.hostPlatform.isLinux then gateway.fhsWithPackages else null;

  goland =
    (mkJetBrainsProduct {
      pname = "goland";
      extraWrapperArgs = [
        # fortify source breaks build since delve compiles with -O0
        ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
      ];
      extraBuildInputs = [
        libgcc
      ];
    }).overrideAttrs
      (attrs: {
        postFixup =
          (attrs.postFixup or "")
          + lib.optionalString stdenv.hostPlatform.isLinux ''
            interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
            patchelf --set-interpreter $interp $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
            chmod +x $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
          '';
      });
  goland-fhs = if stdenv.hostPlatform.isLinux then goland.fhs else null;
  goland-fhsWithPackages = if stdenv.hostPlatform.isLinux then goland.fhsWithPackages else null;

  idea-community-bin = buildIdea {
    pname = "idea-community";
  };

  idea-community-src = buildIdea {
    pname = "idea-community";
    fromSource = true;
  };

  idea-community =
    if stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64 then
      idea-community-bin
    else
      idea-community-src;
  idea-community-fhs = if stdenv.hostPlatform.isLinux then idea-community.fhs else null;
  idea-community-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then idea-community.fhsWithPackages else null;

  idea-ultimate = buildIdea {
    pname = "idea-ultimate";
    extraBuildInputs = [
      lldb
      musl
    ];
  };
  idea-ultimate-fhs = if stdenv.hostPlatform.isLinux then idea-ultimate.fhs else null;
  idea-ultimate-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then idea-ultimate.fhsWithPackages else null;

  mps = mkJetBrainsProduct { pname = "mps"; };
  mps-fhs = if stdenv.hostPlatform.isLinux then mps.fhs else null;
  mps-fhsWithPackages = if stdenv.hostPlatform.isLinux then mps.fhsWithPackages else null;

  phpstorm = mkJetBrainsProduct {
    pname = "phpstorm";
    extraBuildInputs = [
      musl
    ];
  };
  phpstorm-fhs = if stdenv.hostPlatform.isLinux then phpstorm.fhs else null;
  phpstorm-fhsWithPackages = if stdenv.hostPlatform.isLinux then phpstorm.fhsWithPackages else null;

  pycharm-community-bin = buildPycharm { pname = "pycharm-community"; };

  pycharm-community-src = buildPycharm {
    pname = "pycharm-community";
    fromSource = true;
  };

  pycharm-community =
    if stdenv.hostPlatform.isDarwin then pycharm-community-bin else pycharm-community-src;
  pycharm-community-fhs = if stdenv.hostPlatform.isLinux then pycharm-community.fhs else null;
  pycharm-community-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then pycharm-community.fhsWithPackages else null;

  pycharm-professional = buildPycharm {
    pname = "pycharm-professional";
    extraBuildInputs = [ musl ];
  };
  pycharm-professional-fhs = if stdenv.hostPlatform.isLinux then pycharm-professional.fhs else null;
  pycharm-professional-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then pycharm-professional.fhsWithPackages else null;

  rider =
    (mkJetBrainsProduct {
      pname = "rider";
      extraBuildInputs = [
        openssl
        libxcrypt
        lttng-ust_2_12
        musl
      ]
      ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
        expat
        libxml2
        xz
      ];
      extraLdPath = lib.optionals (stdenv.hostPlatform.isLinux) [
        # Avalonia dependencies needed for dotMemory
        libICE
        libSM
        libX11
      ];
    }).overrideAttrs
      (attrs: {
        postInstall =
          (attrs.postInstall or "")
          + lib.optionalString stdenv.hostPlatform.isLinux ''
            ${patchSharedLibs}

            for dir in $out/rider/lib/ReSharperHost/linux-*; do
              rm -rf $dir/dotnet
              ln -s ${dotnet-sdk}/share/dotnet $dir/dotnet
            done
          '';
      });
  rider-fhs = if stdenv.hostPlatform.isLinux then rider.fhs else null;
  rider-fhsWithPackages = if stdenv.hostPlatform.isLinux then rider.fhsWithPackages else null;

  ruby-mine = mkJetBrainsProduct {
    pname = "ruby-mine";
    extraBuildInputs = [
      musl
    ];
  };
  ruby-mine-fhs = if stdenv.hostPlatform.isLinux then ruby-mine.fhs else null;
  ruby-mine-fhsWithPackages = if stdenv.hostPlatform.isLinux then ruby-mine.fhsWithPackages else null;

  rust-rover =
    (mkJetBrainsProduct {
      pname = "rust-rover";
      extraBuildInputs =
        lib.optionals stdenv.hostPlatform.isLinux [
          python3
          openssl
          libxcrypt-legacy
        ]
        ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
          expat
          libxml2
          xz
        ];
    }).overrideAttrs
      (attrs: {
        postFixup = ''
          ${attrs.postFixup or ""}
          ${patchSharedLibs}
        '';
      });
  rust-rover-fhs = if stdenv.hostPlatform.isLinux then rust-rover.fhs else null;
  rust-rover-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then rust-rover.fhsWithPackages else null;

  webstorm = mkJetBrainsProduct {
    pname = "webstorm";
    extraBuildInputs = [
      musl
    ];
  };
  webstorm-fhs = if stdenv.hostPlatform.isLinux then webstorm.fhs else null;
  webstorm-fhsWithPackages = if stdenv.hostPlatform.isLinux then webstorm.fhsWithPackages else null;

  writerside = mkJetBrainsProduct {
    pname = "writerside";
    extraBuildInputs = [
      musl
    ];
  };
  writerside-fhs = if stdenv.hostPlatform.isLinux then writerside.fhs else null;
  writerside-fhsWithPackages =
    if stdenv.hostPlatform.isLinux then writerside.fhsWithPackages else null;

  plugins = callPackage ./plugins { };
}

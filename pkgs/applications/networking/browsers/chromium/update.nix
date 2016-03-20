{ system ? builtins.currentSystem }:

let
  inherit (import ../../../../../. {
    inherit system;
  }) lib runCommand writeText stdenv curl cacert nix;

  sources = if builtins.pathExists ./upstream-info.nix
            then import ./upstream-info.nix
            else {};

  bucketURL = "https://commondatastorage.googleapis.com/"
            + "chromium-browser-official";

  mkVerURL = version: "${bucketURL}/chromium-${version}.tar.xz";

  debURL = "https://dl.google.com/linux/chrome/deb/pool/main/g";

  getDebURL = channelName: version: arch: mirror: let
    packageSuffix = if channelName == "dev" then "unstable" else channelName;
    packageName = "google-chrome-${packageSuffix}";
  in "${mirror}/${packageName}/${packageName}_${version}-1_${arch}.deb";

  # Untrusted mirrors, don't try to update from them!
  debMirrors = [
    "http://95.31.35.30/chrome/pool/main/g"
    "http://mirror.pcbeta.com/google/chrome/deb/pool/main/g"
    "http://repo.fdzh.org/chrome/deb/pool/main/g"
  ];

in rec {
  getChannel = channel: let
    chanAttrs = builtins.getAttr channel sources;
  in {
    inherit (chanAttrs) version;

    main = {
      url = mkVerURL chanAttrs.version;
      inherit (chanAttrs) sha256;
    };

    binary = let
      mkUrls = arch: let
        mkURLForMirror = getDebURL channel chanAttrs.version arch;
      in map mkURLForMirror ([ debURL ] ++ debMirrors);
    in if stdenv.is64bit && chanAttrs ? sha256bin64 then {
      urls = mkUrls "amd64";
      sha256 = chanAttrs.sha256bin64;
    } else if !stdenv.is64bit && chanAttrs ? sha256bin32 then {
      urls = mkUrls "i386";
      sha256 = chanAttrs.sha256bin32;
    } else throw "No Chrome plugins are available for your architecture.";
  };

  update = let
    csv2nix = name: src: import (runCommand "${name}.nix" {
      src = builtins.fetchurl src;
    } ''
      esc() { echo "\"$(echo "$1" | sed -e 's/"\\$/\\&/')\""; }
      IFS=, read -r -a headings <<< "$(head -n1 "$src")"
      echo "[" > "$out"
      tail -n +2 "$src" | while IFS=, read -r -a line; do
        echo "  {"
        for idx in "''${!headings[@]}"; do
          echo "    $(esc "''${headings[idx]}") = $(esc ''${line[$idx]});"
        done
        echo "  }"
      done >> "$out"
      echo "]" >> "$out"
    '');

    channels = lib.fold lib.recursiveUpdate {} (map (attrs: {
      ${attrs.os}.${attrs.channel} = attrs // {
        history = let
          drvName = "omahaproxy-${attrs.os}.${attrs.channel}-info";
          history = csv2nix drvName "http://omahaproxy.appspot.com/history";
          cond = h: attrs.os == h.os && attrs.channel == h.channel
                 && lib.versionOlder h.version attrs.current_version;
          # Note that this is a *reverse* sort!
          sorter = a: b: lib.versionOlder b.version a.version;
          sorted = builtins.sort sorter (lib.filter cond history);
        in map (lib.flip removeAttrs ["os" "channel"]) sorted;
        version = attrs.current_version;
      };
    }) (csv2nix "omahaproxy-info" "http://omahaproxy.appspot.com/all?csv=1"));

    /*
      XXX: This is essentially the same as:

        builtins.tryEval (builtins.fetchurl url)

      ... except that tryEval on fetchurl isn't working and doesn't catch errors
      for fetchurl, so we go for a different approach.

      We only have fixed-output derivations that can have networking access, so
      we abuse MD5 and its weaknesses to forge a fixed-output derivation which
      is not so fixed, because it emits different contents that have the same
      MD5 hash.

      Using this method, we can distinguish whether the URL is available or
      whether it's not based on the actual content.

      So let's use tryEval as soon as it's working with fetchurl in Nix.
    */
    tryFetch = url: let
      mkBin = b: runCommand "binary-blurb" { inherit b; } ''
        h="$(echo "$b" | sed -e ':r;N;$!br;s/[^ \n][^ \n]/\\x&/g;s/[ \n]//g')"
        echo -ne "$h" > "$out"
      '';

      # Both MD5 hash collision examples are from:
      # https://en.wikipedia.org/wiki/MD5#Collision_vulnerabilities
      hashCollTrue = mkBin ''
        d131dd02c5e6eec4 693d9a0698aff95c 2fcab58712467eab 4004583eb8fb7f89
        55ad340609f4b302 83e488832571415a 085125e8f7cdc99f d91dbdf280373c5b
        d8823e3156348f5b ae6dacd436c919c6 dd53e2b487da03fd 02396306d248cda0
        e99f33420f577ee8 ce54b67080a80d1e c69821bcb6a88393 96f9652b6ff72a70
      '';

      hashCollFalse = mkBin ''
        d131dd02c5e6eec4 693d9a0698aff95c 2fcab50712467eab 4004583eb8fb7f89
        55ad340609f4b302 83e4888325f1415a 085125e8f7cdc99f d91dbd7280373c5b
        d8823e3156348f5b ae6dacd436c919c6 dd53e23487da03fd 02396306d248cda0
        e99f33420f577ee8 ce54b67080280d1e c69821bcb6a88393 96f965ab6ff72a70
      '';

      cacheVal = let
        urlHash = builtins.hashString "sha256" url;
        timeSlice = builtins.currentTime / 600;
      in "${urlHash}-${toString timeSlice}";

      successBin = stdenv.mkDerivation {
        name = "tryfetch-${cacheVal}";
        inherit url;

        outputHash = "79054025255fb1a26e4bc422aef54eb4";
        outputHashMode = "flat";
        outputHashAlgo = "md5";

        buildInputs = [ curl ];
        preferLocalBuild = true;

        buildCommand = ''
          if SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt" \
             curl -s -L -f -I "$url" > /dev/null; then
            cat "${hashCollTrue}" > "$out"
          else
            cat "${hashCollFalse}" > "$out"
          fi
        '';

        impureEnvVars = [
          "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
        ];
      };

    in {
      success = builtins.readFile successBin == builtins.readFile hashCollTrue;
      value = builtins.fetchurl url;
    };

    fetchLatest = channel: let
      result = tryFetch (mkVerURL channel.version);
    in if result.success then result.value else fetchLatest (channel // {
      version = if channel.history != []
                then (lib.head channel.history).version
                else throw "Unfortunately there's no older version than " +
                           "${channel.version} available for channel " +
                           "${channel.channel} on ${channel.os}.";
      history = lib.tail channel.history;
    });

    getHash = path: import (runCommand "gethash.nix" {
      inherit path;
      buildInputs = [ nix ];
    } ''
      sha256="$(nix-hash --flat --base32 --type sha256 "$path")"
      echo "\"$sha256\"" > "$out"
    '');

    isLatest = channel: version: let
      ourVersion = sources.${channel}.version or null;
    in if ourVersion == null then false
       else lib.versionOlder version sources.${channel}.version
         || version == sources.${channel}.version;

    # We only support GNU/Linux right now.
    linuxChannels = let
      genLatest = channelName: channel: let
        newUpstream = {
          inherit (channel) version;
          sha256 = getHash (fetchLatest channel);
        };
        keepOld = let
          oldChannel = sources.${channelName};
        in {
          inherit (oldChannel) version sha256;
        } // lib.optionalAttrs (oldChannel ? sha256bin32) {
          inherit (oldChannel) sha256bin32;
        } // lib.optionalAttrs (oldChannel ? sha256bin64) {
          inherit (oldChannel) sha256bin64;
        };
      in if isLatest channelName channel.version then keepOld else newUpstream;
    in lib.mapAttrs genLatest channels.linux;

    getLinuxFlash = channelName: channel: let
      inherit (channel) version;
      fetchArch = arch: tryFetch (getDebURL channelName version arch debURL);
      packages = lib.genAttrs ["i386" "amd64"] fetchArch;
      isNew = arch: attr: !(builtins.hasAttr attr channel)
                       && packages.${arch}.success;
    in channel // lib.optionalAttrs (isNew "i386" "sha256bin32") {
      sha256bin32 = getHash (packages.i386.value);
    } // lib.optionalAttrs (isNew "amd64" "sha256bin64") {
      sha256bin64 = getHash (packages.amd64.value);
    };

    newChannels = lib.mapAttrs getLinuxFlash linuxChannels;

    dumpAttrs = indent: attrs: let
      mkVal = val: if lib.isAttrs val then dumpAttrs (indent + 1) val
                   else "\"${lib.escape ["$" "\\" "\""] (toString val)}\"";
      mkIndent = level: lib.concatStrings (builtins.genList (_: "  ") level);
      mkAttr = key: val: "${mkIndent (indent + 1)}${key} = ${mkVal val};\n";
      attrLines = lib.mapAttrsToList mkAttr attrs;
    in "{\n" + (lib.concatStrings attrLines) + (mkIndent indent) + "}";
  in writeText "chromium-new-upstream-info.nix" ''
    # This file is autogenerated from update.sh in the same directory.
    ${dumpAttrs 0 newChannels}
  '';
}

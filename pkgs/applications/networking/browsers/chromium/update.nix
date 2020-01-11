let maybePkgs = import ../../../../../. {}; in

{ stdenv     ? maybePkgs.stdenv
, runCommand ? maybePkgs.runCommand
, fetchurl   ? maybePkgs.fetchurl
, writeText  ? maybePkgs.writeText
, curl       ? maybePkgs.curl
, cacert     ? maybePkgs.cacert
, nix        ? maybePkgs.nix
}:

let
  inherit (stdenv) lib;

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

in {
  getChannel = channel: let
    chanAttrs = builtins.getAttr channel sources;
  in {
    inherit channel;
    inherit (chanAttrs) version;

    main = fetchurl {
      url = mkVerURL chanAttrs.version;
      inherit (chanAttrs) sha256;
    };

    binary = fetchurl (let
      mkUrls = arch: let
        mkURLForMirror = getDebURL channel chanAttrs.version arch;
      in map mkURLForMirror ([ debURL ] ++ debMirrors);
    in if stdenv.is64bit && chanAttrs ? sha256bin64 then {
      urls = mkUrls "amd64";
      sha256 = chanAttrs.sha256bin64;
    } else if !stdenv.is64bit && chanAttrs ? sha256bin32 then {
      urls = mkUrls "i386";
      sha256 = chanAttrs.sha256bin32;
    } else throw "No Chrome plugins are available for your architecture.");
  };

  update = let
    csv2nix = name: src: import (runCommand "${name}.nix" {
      src = builtins.fetchurl src;
    } ''
      esc() { echo "\"$(echo "$1" | sed -e 's/"\\$/\\&/')\""; } # ohai emacs "
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

      ... except that tryEval on fetchurl isn't working and doesn't catch
      errors for fetchurl, so we go for a different approach.

      We only have fixed-output derivations that can have networking access, so
      we abuse SHA1 and its weaknesses to forge a fixed-output derivation which
      is not so fixed, because it emits different contents that have the same
      SHA1 hash.

      Using this method, we can distinguish whether the URL is available or
      whether it's not based on the actual content.

      So let's use tryEval as soon as it's working with fetchurl in Nix.
    */
    tryFetch = url: let
      # SHA1 hash collisions from https://shattered.io/static/shattered.pdf:
      collisions = runCommand "sha1-collisions" {
        outputs = [ "out" "good" "bad" ];
        base64 = ''
          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
          NC/4ct6rQkPkQHMcV/8XckU4UJCy+VeTA==
        '';
      } ''
        echo "$base64" | base64 -d | tar xj
        mv good.pdf "$good"
        mv bad.pdf "$bad"
        touch "$out"
      '';

      cacheVal = let
        urlHash = builtins.hashString "sha256" url;
        timeSlice = builtins.currentTime / 600;
      in "${urlHash}-${toString timeSlice}";

    in {
      success = import (runCommand "check-success" {
        result = stdenv.mkDerivation {
          name = "tryfetch-${cacheVal}";
          inherit url;

          outputHash = "d00bbe65d80f6d53d5c15da7c6b4f0a655c5a86a";
          outputHashMode = "flat";
          outputHashAlgo = "sha1";

          nativeBuildInputs = [ curl ];
          preferLocalBuild = true;

          inherit (collisions) good bad;

          buildCommand = ''
            if SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt" \
               curl -s -L -f -I "$url" > /dev/null; then
              cp "$good" "$out"
            else
              cp "$bad" "$out"
            fi
          '';

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        };
        inherit (collisions) good;
      } ''
        if cmp -s "$result" "$good"; then
          echo true > "$out"
        else
          echo false > "$out"
        fi
      '');
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
      nativeBuildInputs = [ nix ];
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

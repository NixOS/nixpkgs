{ stdenv
, enablePepperFlash ? false
, enableWideVine ? false

, upstream-info
}:

with stdenv.lib;

let
  plugins = stdenv.mkDerivation {
    name = "chromium-binary-plugins";

    src = upstream-info.binary;

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];
    outputs = [ "flash" "widevine" ];

    unpackCmd = let
      chan = if upstream-info.channel == "dev"    then "chrome-unstable"
        else if upstream-info.channel == "stable" then "chrome"
        else "chrome-${upstream-info.channel}";
    in ''
      mkdir -p plugins
      ar p "$src" data.tar.xz | tar xJ -C plugins --strip-components=4 \
        ./opt/google/${chan}/PepperFlash \
        ./opt/google/${chan}/libwidevinecdm.so \
        ./opt/google/${chan}/libwidevinecdmadapter.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    patchPhase = let
      rpaths = [ stdenv.cc.cc ];
      mkrpath = p: "${makeSearchPath "lib64" p}:${makeSearchPath "lib" p}";
    in ''
      for sofile in PepperFlash/libpepflashplayer.so \
                    libwidevinecdm.so libwidevinecdmadapter.so; do
        chmod +x "$sofile"
        patchelf --set-rpath "${mkrpath rpaths}" "$sofile"
      done

      patchelf --set-rpath "$widevine/lib:${mkrpath rpaths}" \
        libwidevinecdmadapter.so
    '';

    installPhase = let
      wvName = "Widevine Content Decryption Module";
      wvDescription = "Playback of encrypted HTML audio/video content";
      wvMimeTypes = "application/x-ppapi-widevine-cdm";
      wvModule = "$widevine/lib/libwidevinecdmadapter.so";
      wvInfo = "#${wvName}#${wvDescription};${wvMimeTypes}";
    in ''
      flashVersion="$(
        sed -n -r 's/.*"version": "([^"]+)",.*/\1/p' PepperFlash/manifest.json
      )"

      install -vD PepperFlash/libpepflashplayer.so \
        "$flash/lib/libpepflashplayer.so"
      mkdir -p "$flash/nix-support"
      cat > "$flash/nix-support/chromium-plugin.nix" <<NIXOUT
        { flags = [
            "--ppapi-flash-path='$flash/lib/libpepflashplayer.so'"
            "--ppapi-flash-version=$flashVersion"
          ];
        }
      NIXOUT

      install -vD libwidevinecdm.so \
        "$widevine/lib/libwidevinecdm.so"
      install -vD libwidevinecdmadapter.so \
        "$widevine/lib/libwidevinecdmadapter.so"
      mkdir -p "$widevine/nix-support"
      cat > "$widevine/nix-support/chromium-plugin.nix" <<NIXOUT
        { flags = [ "--register-pepper-plugins='${wvModule}${wvInfo}'" ];
          envVars.NIX_CHROMIUM_PLUGIN_PATH_WIDEVINE = "$widevine/lib";
        }
      NIXOUT
    '';

    passthru = let
      enabledPlugins = optional enablePepperFlash plugins.flash
                    ++ optional enableWideVine    plugins.widevine;
      getNix = plugin: import "${plugin}/nix-support/chromium-plugin.nix";
      mergeAttrsets = let
        f = v: if all isAttrs v then mergeAttrsets v
          else if all isList  v then concatLists   v
          else if tail v == []  then head          v
          else head (tail v);
      in fold (l: r: zipAttrsWith (_: f) [ l r ]) {};
    in {
      inherit enabledPlugins;
      settings = mergeAttrsets (map getNix enabledPlugins);
    };
  };
in plugins

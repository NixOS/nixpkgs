{ stdenv
, enablePepperFlash ? false
, enableWideVine ? false

, source
}:

with stdenv.lib;

let
  plugins = stdenv.mkDerivation {
    name = "chromium-binary-plugins";

    # XXX: Only temporary and has to be version-specific
    src = source.plugins;

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];
    outputs = [ "flash" "widevine" ];

    unpackCmd = let
      chan = if source.channel == "dev"    then "chrome-unstable"
        else if source.channel == "stable" then "chrome"
        else "chrome-${source.channel}";
    in ''
      mkdir -p plugins
      ar p "$src" data.tar.lzma | tar xJ -C plugins --strip-components=4 \
        ./opt/google/${chan}/PepperFlash \
        ./opt/google/${chan}/libwidevinecdm.so \
        ./opt/google/${chan}/libwidevinecdmadapter.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    patchPhase = let
      rpaths = [ stdenv.gcc.gcc ];
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
      wvInfo = "#${wvName}#${wvDescription}:${wvMimeTypes}";
    in ''
      flashVersion="$(
        sed -n -r 's/.*"version": "([^"]+)",.*/\1/p' PepperFlash/manifest.json
      )"

      install -vD PepperFlash/libpepflashplayer.so \
        "$flash/lib/libpepflashplayer.so"
      mkdir -p "$flash/nix-support"
      echo "--ppapi-flash-path='$flash/lib/libpepflashplayer.so'" \
           "--ppapi-flash-version=$flashVersion" \
           > "$flash/nix-support/chromium-flags"

      install -vD libwidevinecdm.so \
        "$widevine/lib/libwidevinecdm.so"
      install -vD libwidevinecdmadapter.so \
        "$widevine/lib/libwidevinecdmadapter.so"
      mkdir -p "$widevine/nix-support"
      echo "--register-pepper-plugins='${wvModule}${wvInfo}'" \
        > "$widevine/nix-support/chromium-flags"
      echo "NIX_CHROMIUM_PLUGIN_PATH_WIDEVINE=$widevine/lib" \
        > "$widevine/nix-support/chromium-env-vars"
    '';

    passthru = let
      enabledPlugins = optional enablePepperFlash plugins.flash
                    ++ optional enableWideVine    plugins.widevine;
      getFlags = plugin: "$(< ${plugin}/nix-support/chromium-flags)";
      getEnvVars = plugin: "$(< ${plugin}/nix-support/chromium-env-vars)";
    in {
      flagsEnabled = concatStringsSep " " (map getFlags enabledPlugins);
      envVarsEnabled = concatStringsSep " " (map getEnvVars enabledPlugins);
    };
  };
in plugins

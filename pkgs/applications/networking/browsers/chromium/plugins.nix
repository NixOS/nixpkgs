{ stdenv
, jshon
, enablePepperFlash ? false
, enableWideVine ? false

, source
}:

with stdenv.lib;

let
  # Generate a shell fragment that emits flags appended to the
  # final makeWrapper call for wrapping the browser's main binary.
  #
  # Note that this is shell-escaped so that only the variable specified
  # by the "output" attribute is substituted.
  mkPluginInfo = { output ? "out", allowedVars ? [ output ]
                 , flags ? [], envVars ? {}
                 }: let
    shSearch = ["'"] ++ map (var: "@${var}@") allowedVars;
    shReplace = ["'\\''"] ++ map (var: "'\"\${${var}}\"'") allowedVars;
    # We need to triple-escape "val":
    #  * First because makeWrapper doesn't do any quoting of its arguments by
    #    itself.
    #  * Second because it's passed to the makeWrapper call separated by IFS but
    #    not by the _real_ arguments, for example the Widevine plugin flags
    #    contain spaces, so they would end up as separate arguments.
    #  * Third in order to be correctly quoted for the "echo" call below.
    shEsc = val: "'${replaceStrings ["'"] ["'\\''"] val}'";
    mkSh = val: "'${replaceStrings shSearch shReplace (shEsc val)}'";
    mkFlag = flag: ["--add-flags" (shEsc flag)];
    mkEnvVar = key: val: ["--set" (shEsc key) (shEsc val)];
    envList = mapAttrsToList mkEnvVar envVars;
    quoted = map mkSh (flatten ((map mkFlag flags) ++ envList));
  in ''
    mkdir -p "''$${output}/nix-support"
    echo ${toString quoted} > "''$${output}/nix-support/wrapper-flags"
  '';

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
      wvModule = "@widevine@/lib/libwidevinecdmadapter.so";
      wvInfo = "#${wvName}#${wvDescription};${wvMimeTypes}";
    in ''
      flashVersion="$(
        "${jshon}/bin/jshon" -F PepperFlash/manifest.json -e version -u
      )"

      install -vD PepperFlash/libpepflashplayer.so \
        "$flash/lib/libpepflashplayer.so"

      ${mkPluginInfo {
        output = "flash";
        allowedVars = [ "flash" "flashVersion" ];
        flags = [
          "--ppapi-flash-path=@flash@/lib/libpepflashplayer.so"
          "--ppapi-flash-version=@flashVersion@"
        ];
      }}

      install -vD libwidevinecdm.so \
        "$widevine/lib/libwidevinecdm.so"
      install -vD libwidevinecdmadapter.so \
        "$widevine/lib/libwidevinecdmadapter.so"

      ${mkPluginInfo {
        output = "widevine";
        flags = [ "--register-pepper-plugins=${wvModule}${wvInfo}" ];
        envVars.NIX_CHROMIUM_PLUGIN_PATH_WIDEVINE = "@widevine@/lib";
      }}
    '';

    passthru.enabled = optional enablePepperFlash plugins.flash
                    ++ optional enableWideVine    plugins.widevine;
  };
in plugins

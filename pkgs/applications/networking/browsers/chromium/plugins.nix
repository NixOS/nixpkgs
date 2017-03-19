{ stdenv
, jshon
, fetchzip
, enablePepperFlash ? false
, enableWideVine ? false

, upstream-info
}:

with stdenv.lib;

let
  mkrpath = p: "${makeSearchPathOutput "lib" "lib64" p}:${makeLibraryPath p}";

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

  widevine = stdenv.mkDerivation {
    name = "chromium-binary-plugin-widevine";

    src = upstream-info.binary;

    phases = [ "unpackPhase" "patchPhase" "installPhase" "checkPhase" ];

    unpackCmd = let
      chan = if upstream-info.channel == "dev"    then "chrome-unstable"
        else if upstream-info.channel == "stable" then "chrome"
        else "chrome-${upstream-info.channel}";
    in ''
      mkdir -p plugins
      ar p "$src" data.tar.xz | tar xJ -C plugins --strip-components=4 \
        ./opt/google/${chan}/libwidevinecdm.so \
        ./opt/google/${chan}/libwidevinecdmadapter.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    patchPhase = ''
      for sofile in libwidevinecdm.so libwidevinecdmadapter.so; do
        chmod +x "$sofile"
        patchelf --set-rpath "${mkrpath [ stdenv.cc.cc ]}" "$sofile"
      done

      patchelf --set-rpath "$out/lib:${mkrpath [ stdenv.cc.cc ]}" \
        libwidevinecdmadapter.so
    '';

    installPhase = let
      wvName = "Widevine Content Decryption Module";
      wvDescription = "Playback of encrypted HTML audio/video content";
      wvMimeTypes = "application/x-ppapi-widevine-cdm";
      wvModule = "@out@/lib/libwidevinecdmadapter.so";
      wvInfo = "#${wvName}#${wvDescription};${wvMimeTypes}";
    in ''
      install -vD libwidevinecdm.so \
        "$out/lib/libwidevinecdm.so"
      install -vD libwidevinecdmadapter.so \
        "$out/lib/libwidevinecdmadapter.so"

      ${mkPluginInfo {
        flags = [ "--register-pepper-plugins=${wvModule}${wvInfo}" ];
        envVars.NIX_CHROMIUM_PLUGIN_PATH_WIDEVINE = "@out@/lib";
      }}
    '';
  };

  flash = stdenv.mkDerivation rec {
    name = "flashplayer-ppapi-${version}";
    version = "25.0.0.127";

    src = fetchzip {
      url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/"
          + "${version}/flash_player_ppapi_linux.x86_64.tar.gz";
      sha256 = "1gf0ncclkk3h4vj9kkhbqj1nnnm54gwm5mdcs4p4pl8i339scs14";
      stripRoot = false;
    };

    patchPhase = ''
      chmod +x libpepflashplayer.so
      patchelf --set-rpath "${mkrpath [ stdenv.cc.cc ]}" libpepflashplayer.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    installPhase = ''
      flashVersion="$(
        "${jshon}/bin/jshon" -F manifest.json -e version -u
      )"

      install -vD libpepflashplayer.so "$out/lib/libpepflashplayer.so"

      ${mkPluginInfo {
        allowedVars = [ "out" "flashVersion" ];
        flags = [
          "--ppapi-flash-path=@out@/lib/libpepflashplayer.so"
          "--ppapi-flash-version=@flashVersion@"
        ];
      }}
    '';

    dontStrip = true;
  };

in {
  enabled = optional enableWideVine widevine
         ++ optional enablePepperFlash flash;
}

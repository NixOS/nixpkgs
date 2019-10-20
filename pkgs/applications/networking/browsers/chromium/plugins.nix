{ stdenv, gcc
, jshon
, glib
, nspr
, nss
, fetchzip
, patchelfUnstable
, enablePepperFlash ? false

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

  flash = stdenv.mkDerivation rec {
    pname = "flashplayer-ppapi";
    version = "32.0.0.270";

    src = fetchzip {
      url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/${version}/flash_player_ppapi_linux.x86_64.tar.gz";
      sha256 = "1z8nfw7b3dsy79gb50bmmdjz66j5gx6m0hkw1abp35xdgh2sz2ak";
      stripRoot = false;
    };

    patchPhase = ''
      chmod +x libpepflashplayer.so
      patchelf --set-rpath "${mkrpath [ gcc.cc ]}" libpepflashplayer.so
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

    meta = {
      license = stdenv.lib.licenses.unfree;
      maintainers = with stdenv.lib.maintainers; [ taku0 ];
      platforms = platforms.x86_64;
    };
  };

in {
  enabled = optional enablePepperFlash flash;
}

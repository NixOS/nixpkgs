{ lib, stdenv, buildEnv, fetchurl, mono }:

let
  version = "1.5.9";
  drv = stdenv.mkDerivation {
    pname = "keeotp2";
    inherit version;

    src = fetchurl {
      url    = "https://github.com/tiuub/KeeOtp2/releases/download/v${version}/KeeOtp2.plgx";
      sha256 = "f5c797cea710e0cd170c47133d6144faa8d14b9c3d1e045da2d08c82682990c9";
    };

    meta = with lib; {
      description = "KeeOtp2 is a plugin for KeePass. It provides a form to display one time passwords and is fully compatible with the built-in OTP function.";
      homepage    = "https://github.com/tiuub/KeeOtp2";
      platforms   = with lib.platforms; linux;
      license     = licenses.mit;
      maintainers = [ ];
    };

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $src $out/lib/dotnet/keepass/
    '';
  };
in
  # Mono is required to compile plugin at runtime, after loading.
  buildEnv { name = drv.name; paths = [ mono drv ]; }

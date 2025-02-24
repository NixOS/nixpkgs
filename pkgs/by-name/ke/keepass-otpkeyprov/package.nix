{
  lib,
  stdenv,
  buildEnv,
  fetchzip,
  mono,
}:

let
  version = "2.6";
  drv = stdenv.mkDerivation {
    pname = "otpkeyprov";
    inherit version;

    src = fetchzip {
      url = "https://keepass.info/extensions/v2/otpkeyprov/OtpKeyProv-${version}.zip";
      sha256 = "1p60k55v2sxnv1varmp0dgbsi2rhjg9kj19cf54mkc87nss5h1ki";
      stripRoot = false;
    };

    meta = {
      description = "OtpKeyProv is a key provider based on one-time passwords";
      homepage = "https://keepass.info/plugins.html#otpkeyprov";
      platforms = with lib.platforms; linux;
      license = lib.licenses.gpl2;
      maintainers = [ lib.maintainers.Enteee ];
    };

    pluginFilename = "OtpKeyProv.plgx";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
  };
in
# Mono is required to compile plugin at runtime, after loading.
buildEnv {
  name = drv.name;
  paths = [
    mono
    drv
  ];
}

{
  lib,
  mkFranzDerivation,
  fetchurl,
  xorg,
  xdg-utils,
  buildEnv,
  writeShellScriptBin,
}:

let
  mkFranzDerivation' = mkFranzDerivation.override {
    xdg-utils = buildEnv {
      name = "xdg-utils-for-ferdi";
      paths = [
        xdg-utils
        (lib.hiPrio (
          writeShellScriptBin "xdg-open" ''
            unset GDK_BACKEND
            exec ${xdg-utils}/bin/xdg-open "$@"
          ''
        ))
      ];
    };
  };
in
mkFranzDerivation' rec {
  pname = "ferdi";
  name = "Ferdi";
  version = "5.8.1";
  src = fetchurl {
    url = "https://master.dl.sourceforge.net/project/ferdi.mirror/v${version}/ferdi_${version}_amd64.deb";
    sha256 = "sha256-Bl7bM5iDQlfPSZxksqlg7GbuwWlm53QkOf/TQEg3/n0=";
  };
  extraBuildInputs = [ xorg.libxshmfence ];
  meta = with lib; {
    description = "Combine your favorite messaging services into one application";
    homepage = "https://getferdi.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    knownVulnerabilities = [
      "CVE-2022-32320"
    ];
  };
}

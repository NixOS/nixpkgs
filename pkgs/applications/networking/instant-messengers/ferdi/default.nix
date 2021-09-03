{ lib, mkFranzDerivation, fetchurl, xorg, xdg-utils, buildEnv, writeShellScriptBin }:

let
  mkFranzDerivation' = mkFranzDerivation.override {
    xdg-utils = buildEnv {
      name = "xdg-utils-for-ferdi";
      paths = [
        xdg-utils
        (lib.hiPrio (writeShellScriptBin "xdg-open" ''
          unset GDK_BACKEND
          exec ${xdg-utils}/bin/xdg-open "$@"
        ''))
      ];
    };
  };
in
mkFranzDerivation' rec {
  pname = "ferdi";
  name = "Ferdi";
  version = "5.6.0";
  src = fetchurl {
    url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
    sha256 = "sha256-yaAYNQAvbtArw9qAtbTDD11a9nH2OQEPE8QLg1E79Yc=";
  };
  extraBuildInputs = [ xorg.libxshmfence ];
  meta = with lib; {
    description = "Combine your favorite messaging services into one application";
    homepage = "https://getferdi.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ma27 ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}

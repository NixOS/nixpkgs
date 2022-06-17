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
  pname = "ferdium";
  version = "6.0.0-nightly.40";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v6.0.0-nightly.40/ferdium_6.0.0-nightly.40_amd64.deb";
    sha256 = "sha256-pDVWVUQRJqFyaMGIhMekNzz8DVq+B8M3fD0JC8+7x2E=";
  };

  extraBuildInputs = [ xorg.libxshmfence ];

  meta = with lib; {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnouvean ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}

{ lib, stdenv, undmg, fetchurl }:

stdenv.mkDerivation rec {
  pname = "lens";
  version = "2022.12";
  build = "${version}.11410-latest";
  appName = "Lens";

  sourceRoot = "${appName}.app";

  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}-arm64.dmg";
    sha256 = "sha256-PKWJ2CZ/wacbJnrCZdYwYJzbFVhjIGAw60UGhdw11Mc=";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "aarch64-darwin" ];
  };
}

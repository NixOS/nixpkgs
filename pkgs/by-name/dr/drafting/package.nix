{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "drafting";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Drafting";
    rev = "14182b3381808ecb310dbe83673ae86a7e4e0e2d";
    hash = "sha256-Ejo4getOk8gx6fxhZlvh4AAJrJtWJH0UyEpG+a+26wI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/indestructible-type/Drafting";
    description = "A monospace font by Indestructible Type";
    license = licenses.ofl;
    maintainers = [ maintainers.locorock ];
  };
}

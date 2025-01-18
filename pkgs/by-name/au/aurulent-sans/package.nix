{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "aurulent-sans";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "deepfire";
    repo = "hartke-aurulent-sans";
    rev = "${pname}-${version}";
    hash = "sha256-M/duhgqxXZJq5su9FrsGjZdm+wtO5B5meoDomde+GwY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Aurulent Sans";
    longDescription = "Aurulent Sans is a humanist sans serif intended to be used as an interface font.";
    homepage = "http://delubrum.org/";
    maintainers = with maintainers; [ deepfire ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

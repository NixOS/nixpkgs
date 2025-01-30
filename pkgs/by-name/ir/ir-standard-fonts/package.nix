{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ir-standard-fonts";
  version = "20170121";

  src = fetchFromGitHub {
    owner = "molaeiali";
    repo = pname;
    rev = version;
    hash = "sha256-o1d8SBX3nf7g6Gh4OP+JRS+LNrHTQOIiHhW3VNCkDV0=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/ir-standard-fonts {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/morealaz/ir-standard-fonts";
    description = "Iran Supreme Council of Information and Communication Technology (SCICT) standard Persian fonts series";
    # License information is unavailable.
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = [ ];
  };
}

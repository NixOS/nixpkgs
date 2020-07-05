{ lib, mkDerivation, fetchFromGitHub, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "kristall";
  version = "0.3";
  src = fetchFromGitHub {
    owner = "MasterQ32";
    repo = "kristall";
    rev = "V" + version;
    sha256 = "07nf7w6ilzs5g6isnvsmhh4qa1zsprgjyf0zy7rhpx4ikkj8c8zq";
  };

  buildInputs = [ qtbase qtmultimedia ];

  qmakeFlags = [ "src/kristall.pro" ];

  installPhase = ''
    install -Dt $out/bin kristall
    install -D Kristall.desktop $out/share/applications/net.random-projects.kristall.desktop
  '';

  meta = with lib;
    src.meta // {
      description =
        "Graphical small-internet client, supports gemini, http, https, gopher, finger";
      homepage = "https://random-projects.net/projects/kristall.gemini";
      maintainers = with maintainers; [ ehmry ];
      license = licenses.gpl3;
      inherit (qtmultimedia.meta) platforms;
    };
}

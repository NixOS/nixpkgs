{ lib, mkDerivation, fetchFromGitHub, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "kristall";
  version = "0.2";
  src = fetchFromGitHub {
    owner = "MasterQ32";
    repo = "kristall";
    rev = "V" + version;
    sha256 = "08k3rg0sa91ra0nzla5rw806nnncnyvq1s7k09k5i74fvcsnpqyp";
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
      inherit (qtmultimedia.meta) platforms;
    };
}

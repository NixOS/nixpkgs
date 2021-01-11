{ lib, stdenv, mkDerivation, fetchFromGitHub, installShellFiles,
  qmake, qtbase, poppler, qtmultimedia }:

mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "1nbcqrfdjcsc6czqk1v163whka4x1w883b1298aws8yi7vac4f1i";
  };

  nativeBuildInputs = [ qmake installShellFiles ];
  buildInputs = [ qtbase qtmultimedia poppler ];

  postPatch = ''
    # Fix location of poppler-*.h
    shopt -s globstar
    for f in **/*.{h,cpp}; do
      substituteInPlace $f --replace '#include <poppler-' '#include <poppler/qt5/poppler-'
    done
  '';

  installPhase = ''
    install -m755 beamerpresenter -Dt $out/bin/
    install -m644 src/icons/beamerpresenter.svg -Dt $out/share/icons/hicolor/scalable/apps/
    install -m644 share/applications/beamerpresenter.desktop -Dt $out/share/applications/
    installManPage man/*.{1,5}
  '';

  meta = with lib; {
    description = "Simple dual screen pdf presentation software";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien ];
  };
}

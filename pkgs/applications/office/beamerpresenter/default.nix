{ stdenv, mkDerivation, fetchFromGitHub, installShellFiles,
  qmake, qtbase, poppler, qtmultimedia }:

mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "12xngnhwa3haf0pdxczgvhq1j20zbsr30y2bfn9qwmlhbwklhkj2";
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

  meta = with stdenv.lib; {
    description = "Simple dual screen pdf presentation software";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien ];
  };
}

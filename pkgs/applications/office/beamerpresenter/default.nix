{ stdenv, mkDerivation, fetchFromGitHub, makeDesktopItem, installShellFiles,
  qmake, qtbase, poppler, qtmultimedia }:

mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "0j7wx3qqwhda33ig2464bi0j0a473y5p7ndy5f7f8x9cqdal1d01";
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
    install -m644 $desktopItem/share/applications/*.desktop -Dt $out/share/applications/
    installManPage man/*.{1,5}
  '';

  # TODO: replace with upstream's .desktop file once available.
  # https://github.com/stiglers-eponym/BeamerPresenter/pull/4
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "BeamerPresenter";
    genericName = "Beamer presentation viewer";
    comment = "Simple dual screen pdf presentation software";
    icon = "beamerpresenter";
    categories = "Office;";
    exec = "beamerpresenter %F";
    mimeType = "application/pdf;application/x-pdf;";
  };

  meta = with stdenv.lib; {
    description = "Simple dual screen pdf presentation software";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien ];
  };
}

{ lib, stdenv, fetchFromGitHub, cmake, qtsvg, qtwebengine, wrapQtAppsHook, qttools }:

stdenv.mkDerivation rec {
  pname = "pageedit";
  version = "1.9.20";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = pname;
    rev = version;
    hash = "sha256-naoflFANeMwabbdrNL3+ndvEXYT4Yqf+Mo77HcCexHE=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools ];
  propagatedBuildInputs = [ qtsvg qtwebengine ];
  cmakeFlags = [ "-DINSTALL_BUNDLED_DICTS=0" ];

  installPhase =
    if stdenv.isDarwin then ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r bin/PageEdit.app $out/Applications
      makeWrapper $out/Applications/PageEdit.app/Contents/MacOS/PageEdit $out/bin/pageedit

      runHook postInstall
    '' else null;

  meta = with lib; {
    description = "ePub XHTML Visual Editor";
    homepage = "https://sigil-ebook.com/pageedit/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.pasqui23 ];
    platforms = platforms.all;
  };
}

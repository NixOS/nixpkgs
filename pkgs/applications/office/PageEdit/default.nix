<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, qtsvg, qtwebengine, wrapQtAppsHook, qttools }:

stdenv.mkDerivation rec {
  pname = "pageedit";
  version = "2.0.0";
=======
{ lib, stdenv, mkDerivation, fetchFromGitHub, cmake, qtsvg, qtwebengine, qttranslations, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "pageedit";
  version = "1.9.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-zwOSt1eyvuuqfQ1G2bCB4yj6GgixFRc2FLOgcCrdg3Q=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools ];
=======
    hash = "sha256-naoflFANeMwabbdrNL3+ndvEXYT4Yqf+Mo77HcCexHE=";
  };

  nativeBuildInputs = [ cmake qttranslations wrapQtAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

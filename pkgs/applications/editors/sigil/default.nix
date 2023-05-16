{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, makeWrapper
, boost, xercesc, qtbase, qttools, qtwebengine, qtxmlpatterns
, python3Packages
}:

mkDerivation rec {
  pname = "sigil";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "1.9.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "Sigil";
    owner = "Sigil-Ebook";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-d54N6Kb+xLMxlRwqxqWXnFGQCvUmSy9z6j86aV+VioU=";
=======
    sha256 = "sha256-07JK3xHpNDs6CU8je8PNyTugNBi2mQ7G109R3JX4eyg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [
    boost xercesc qtbase qttools qtwebengine qtxmlpatterns
    python3Packages.lxml
  ];

  prePatch = ''
    sed -i '/^QTLIB_DIR=/ d' src/Resource_Files/bash/sigil-sh_install
  '';

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = licenses.gpl3;
    # currently unmaintained
    platforms = platforms.linux;
  };
}

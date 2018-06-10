{ lib
, substituteAll
, buildPythonApplication
, fetchFromGitHub
, distutils_extra
, setuptools-git
, intltool
, pygtk
, libX11
, libXtst
, wrapGAppsHook
, defaultIconTheme
, hicolor_icon_theme
}:
buildPythonApplication rec {
  pname = "screenkey";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "screenkey";
    rev = "screenkey-${version}";
    sha256 = "14g7fiv9n7m03djwz1pp5034pffi87ssvss9bc1q8vq0ksn23vrw";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit libX11 libXtst;
    })
  ];

  nativeBuildInputs = [
    distutils_extra
    setuptools-git
    intltool

    wrapGAppsHook
  ];

  buildInputs = [
    defaultIconTheme
    hicolor_icon_theme
  ];

  propagatedBuildInputs = [
    pygtk
  ];

  # screenkey does not have any tests
  doCheck = false;

  meta = with lib; {
    homepage = https://www.thregr.org/~wavexx/software/screenkey/;
    description = "A screencast tool to display your keys inspired by Screenflick";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}

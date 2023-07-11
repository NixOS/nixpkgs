{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qtscript, qtsvg,
  wrapQtAppsHook, poppler, zlib, pkg-config }:

mkDerivation rec {
  pname = "texstudio";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    hash = "sha256-L+q4+k4XWywnxIvhfXPCBeCqnGj4E9BhAmgcAZhm7S8=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook pkg-config ];
  buildInputs = [ qtbase qtscript qtsvg poppler zlib ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${version}/utilities/manual/CHANGELOG.txt";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 cfouche ];
  };
}

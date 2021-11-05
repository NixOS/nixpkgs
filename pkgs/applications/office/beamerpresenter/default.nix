{ lib, stdenv, fetchFromGitHub, installShellFiles,
  qmake, qtbase, qtmultimedia, wrapQtAppsHook,
  poppler, mupdf, freetype, jbig2dec, openjpeg, gumbo,
  renderer ? "mupdf" }:

let
  renderers = {
    mupdf.buildInputs = [ mupdf freetype jbig2dec openjpeg gumbo ];
    poppler.buildInputs = [ poppler ];
  };

in

stdenv.mkDerivation rec {
  pname = "beamerpresenter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "stiglers-eponym";
    repo = "BeamerPresenter";
    rev = "v${version}";
    sha256 = "10i5nc5b5syaqvsixam4lmfiz3b5cphbjfgfqavi5jilq769792a";
  };

  nativeBuildInputs = [ qmake installShellFiles wrapQtAppsHook ];
  buildInputs = [ qtbase qtmultimedia ] ++ renderers.${renderer}.buildInputs;

  qmakeFlags = [ "RENDERER=${renderer}" ];

  postPatch = ''
    shopt -s globstar
    for f in **/*.{pro,conf,h,cpp}; do
      substituteInPlace "$f" \
        --replace "/usr/" "$out/" \
        --replace "/etc/" "$out/etc/" \
        --replace '$${GUI_CONFIG_PATH}' "$out/etc/xdg/beamerpresenter/gui.json"
    done
  '';

  meta = with lib; {
    description = "Modular multi screen pdf presentation software respecting your window manager";
    homepage = "https://github.com/stiglers-eponym/BeamerPresenter";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pacien ];
  };
}

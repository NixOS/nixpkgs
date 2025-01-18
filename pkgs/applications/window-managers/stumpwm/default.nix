{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  sbcl,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stumpwm";
  version = "24.11";

  src = fetchFromGitHub {
    owner = "stumpwm";
    repo = "stumpwm";
    rev = "${finalAttrs.version}";
    hash = "sha256-Ba2HcAmNcZvnqU0jpLTxsBe8L+4aHbO/oM4Bp/IYEC0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    sbcl
    texinfo
  ];

  doCheck = true;

  postConfigure = ''
    export ASDF_OUTPUT_TRANSLATIONS=$(pwd):$(pwd)
  '';

  meta = with lib; {
    description = "Tiling, keyboard driven window manager";
    homepage = "https://stumpwm.github.io/";
    license = licenses.gpl2Plus;
    mainProgram = "stumpwm";
    maintainers = teams.lisp.members;
    platforms = platforms.unix;
  };
})

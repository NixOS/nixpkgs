{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "urxvt-resize-font";
  version = "2019-10-05";
  dontPatchShebangs = true;

  src = fetchFromGitHub {
    owner = "simmel";
    repo = "urxvt-resize-font";
    rev = "e966a5d77264e9263bfc8a51e160fad24055776b";
    hash = "sha256-cG5i2CKe4e9Mv31X6c4Se+u5ClUiXpdsgP/P5vQaS6E=";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp resize-font $out/lib/urxvt/perl
  '';

  meta = {
    description = "URxvt Perl extension for resizing the font";
    homepage = "https://github.com/simmel/urxvt-resize-font";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,

  boca,
  smooth,
  systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freac";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bHoRxxhSM7ipRkiBG7hEa1Iw8Z3tOHQ/atngC/3X1a4=";
  };

  buildInputs = [
    boca
    smooth
    systemd
    wrapGAppsHook3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = {
    description = "Audio converter and CD ripper with support for various popular formats and encoders";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.freac.org/";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gfortran,
  cairo,
  freetype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "giza";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "danieljprice";
    repo = "giza";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tNz0Lh6bzQPxsd/Vz3jh8u0JiRXT0O43hyfgbGTJUeE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gfortran
  ];

  buildInputs = [
    cairo
    freetype
  ];

  meta = {
    description = "Scientific plotting library for C/Fortran";
    inherit (finalAttrs.src.meta) homepage;
    changelog = "${finalAttrs.src.meta.homepage}/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})

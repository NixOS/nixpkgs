{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fmt_11,
  glib,
  libpaper,
  pango,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paps";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "dov";
    repo = "paps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4SZOIV5Lp1qqC1RH+jYYfgOMmh7uBELIB1o1Bhrtzbw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    fmt_11
    glib
    libpaper
    pango
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Pango to PostScript converter";
    homepage = "https://github.com/dov/paps";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.linux;
    mainProgram = "paps";
  };
})

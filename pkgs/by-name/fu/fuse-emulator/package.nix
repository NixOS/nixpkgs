{
  lib,
  stdenv,
  fetchurl,
  SDL2,
  glib,
  gtk3,
  libpng,
  libspectrum,
  libxml2,
  perl,
  pkg-config,
  versionCheckHook,
  wrapGAppsHook3,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-emulator";
  version = "1.10.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://sourceforge/fuse-emulator/fuse-${finalAttrs.version}.tar.gz";
    hash = "sha256-9XzTDxW6xvt6hzsO5AbrABRhdpH2ZcqgHQAWJLSVPpc=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    glib
    gtk3
    libpng
    libspectrum
    libxml2
    zlib
  ];

  configureFlags = [ "--enable-desktop-integration" ];

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  enableParallelBuilding = true;

  meta = {
    description = "ZX Spectrum emulator";
    homepage = "https://fuse-emulator.sourceforge.net/";
    changelog = "https://sourceforge.net/p/fuse-emulator/fuse/ci/fuse-${finalAttrs.version}/tree/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "fuse";
  };
})

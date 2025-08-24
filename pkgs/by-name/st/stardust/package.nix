{
  lib,
  stdenv,
  fetchurl,
  zlib,
  libtiff,
  libxml2,
  SDL_compat,
  libX11,
  libXi,
  libXmu,
  libXext,
  libGLU,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stardust";
  version = "0.1.13";

  src = fetchurl {
    url = "http://iwar.free.fr/spip/IMG/gz/stardust-${finalAttrs.version}.tar.gz";
    hash = "sha256-t5cykB5zHYYj4tlk9QDhL7YQVgEScBZw9OIVXz5NOqc=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    SDL_compat
    libxml2
  ];
  buildInputs = [
    zlib
    libtiff
    libxml2
    SDL_compat
    libX11
    libXi
    libXmu
    libXext
    libGLU
    libGL
  ];

  patches = [ ./pointer-fix.patch ];

  installFlags = [ "bindir=${placeholder "out"}/bin" ];

  hardeningDisable = [ "format" ];

  postConfigure = ''
    substituteInPlace config.h \
      --replace-fail '#define PACKAGE ""' '#define PACKAGE "stardust"'
  '';

  meta = {
    description = "Space flight simulator";
    homepage = "http://iwar.free.fr/spip/rubrique2.html";
    mainProgram = "stardust";
    maintainers = with lib.maintainers; [
      raskin
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})

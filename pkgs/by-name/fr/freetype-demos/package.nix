{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  freetype,
  zlib,
  bzip2,
  brotli,
  libpng,
  librsvg,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freetype-demos";
  # must match freetype.version: the demos build against the FreeType
  # source tree of the same release
  version = "2.14.3";

  src = fetchurl {
    url = "mirror://savannah/freetype/ft2demos-${finalAttrs.version}.tar.xz";
    hash = "sha256-GslqBmw5EI8rDMiqgFEG7Sw4FGyJE9wjltwkLpHjVoY=";
  };

  # Some demos (e.g. ttdebug) need FreeType internal headers, so
  # upstream builds FreeType as a static meson subproject whose wrap
  # file fetches git HEAD. Provide the matching release tarball
  # instead — the wrap download is unavailable in the sandbox.
  postPatch = ''
    mkdir -p subprojects/freetype2
    tar -xf ${freetype.src} -C subprojects/freetype2 --strip-components=1
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    zlib
    bzip2
    brotli
    libpng
    librsvg
    libx11
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Demo and diagnostic programs for FreeType (ftview, ftgrid, ftdump, ...)";
    homepage = "https://www.freetype.org/";
    changelog = "https://gitlab.freedesktop.org/freetype/freetype-demos/-/raw/VER-${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }/ChangeLog";
    license = lib.licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    platforms = lib.platforms.unix;
    mainProgram = "ftview";
    maintainers = with lib.maintainers; [ fraggerfox ];
  };
})

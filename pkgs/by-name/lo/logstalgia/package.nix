{
  lib,
  stdenv,
  fetchurl,
  SDL2,
  ftgl,
  autoreconfHook,
  pkg-config,
  libpng,
  libjpeg,
  pcre2,
  SDL2_image,
  glew,
  libGLU,
  libGL,
  libx11,
  boost,
  glm,
  freetype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logstalgia";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-${finalAttrs.version}/logstalgia-${finalAttrs.version}.tar.gz";
    hash = "sha256-wEnv9AXpJANSIu2ya8xse18AoIkmq9t7Rn4kSSQnkKk=";
  };

  postPatch = ''
    # Fix build with boost 1.89
    rm m4/ax_boost_system.m4
    substituteInPlace configure.ac \
      --replace-fail "AX_BOOST_SYSTEM" ""
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glew
    SDL2
    ftgl
    libpng
    libjpeg
    libx11
    pcre2
    SDL2_image
    libGLU
    libGL
    boost
    glm
    freetype
  ];

  configureFlags = [
    "--with-boost-system=boost_system"
    "--with-boost-filesystem=boost_filesystem"
  ];

  meta = {
    homepage = "https://logstalgia.io/";
    description = "Website traffic visualization tool";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Logstalgia is a website traffic visualization that replays or
      streams web-server access logs as a pong-like battle between the
      web server and an never ending torrent of requests.

      Requests appear as colored balls (the same color as the host)
      which travel across the screen to arrive at the requested
      location. Successful requests are hit by the paddle while
      unsuccessful ones (eg 404 - File Not Found) are missed and pass
      through.

      The paths of requests are summarized within the available space by
      identifying common path prefixes. Related paths are grouped
      together under headings. For instance, by default paths ending in
      png, gif or jpg are grouped under the heading Images. Paths that
      don’t match any of the specified groups are lumped together under
      a Miscellaneous section.
    '';

    platforms = lib.platforms.gnu ++ lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "logstalgia";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sdl3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mojoal";
  version = "0-unstable-2026-04-27";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "mojoAL";
    rev = "205516a0b4eac829fb4baf6906b4e1864277cdab";
    hash = "sha256-JMkeeXJDHqtIuLoI7ku5bahAa+aYfwljWDkWGgKg858=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sdl3 ];

  postPatch = ''
    cat >> CMakeLists.txt <<'EOF'
    include(GNUInstallDirs)
    install(TARGETS mojoal
      LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}
      ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR})
    install(DIRECTORY AL DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR})
    EOF
  '';

  meta = {
    description = "Simple drop-in OpenAL implementation backed by SDL";
    homepage = "https://github.com/icculus/mojoAL";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

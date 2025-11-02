{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  version,
  src,
}:

stdenv.mkDerivation rec {
  pname = "glm";
  inherit version src;

  outputs = [
    "out"
    "doc"
  ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    # Remove when https://github.com/g-truc/glm/pull/1001 merged & in release.
    # Relies on <endian.h>, Linux-specific
    ./1001-glm-Fix-packing-on-BE.patch
  ];

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE =
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102823
    if (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") then
      "-fno-ipa-modref"
    # Fix compilation errors on darwin
    else if (stdenv.cc.isClang) then
      "-Wno-error"
    else
      "";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "BUILD_STATIC_LIBS" false)
    (lib.cmakeBool "GLM_TEST_ENABLE" doCheck)
  ];

  doCheck = true;

  postInstall = ''
    # Install pkg-config file
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./glm.pc.in} $out/lib/pkgconfig/glm.pc

    # Install docs
    mkdir -p $doc/share/doc/glm
    cp -rv ../doc/api $doc/share/doc/glm/html
    cp -v ../doc/manual.pdf $doc/share/doc/glm
  '';

  meta = with lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = "https://github.com/g-truc/glm";
    license = licenses.mit;
    platforms = platforms.unix;
    # https://github.com/g-truc/glm/issues/897 indicates that packing isn't implemented properly on non-LE.
    # Patch from https://github.com/g-truc/glm/pull/1001 currently relies on Linux-only header.
    broken = !stdenv.hostPlatform.isLittleEndian && !stdenv.hostPlatform.isLinux;
    maintainers = with maintainers; [ smancill ];
  };
}

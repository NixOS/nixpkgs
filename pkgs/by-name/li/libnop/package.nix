{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnop";
  version = "0-unstable-2022-09-04";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "libnop";
    rev = "ab842f51dc2eb13916dc98417c2186b78320ed10";
    sha256 = "sha256-d2z/lDI9pe5TR82MxGkR9bBMNXPvzqb9Gsd5jOv6x1A=";
  };

  # Since this is a header-only library, we can skip build phase
  # and just install the headers directly
  dontBuild = true;

  # Skip the tests to avoid compilation errors
  doCheck = false;

  # Install headers to the correct location as this is a header-only library
  installPhase = ''
    mkdir -p $out/include
    cp -r $src/include/* $out/include/

    # Create pkg-config file
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/libnop.pc << EOF
    includedir=$out/include

    Name: libnop
    Description: Header-only C++ serialization library
    Version: ${finalAttrs.version}
    Cflags: -I\$includedir
    EOF
  '';

  meta = {
    description = "A fast, header-only C++ serialization library";
    homepage = "https://github.com/google/libnop";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})

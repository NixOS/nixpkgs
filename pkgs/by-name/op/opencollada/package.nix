{
  cmake,
  dos2unix,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libxml2,
  pcre,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "opencollada";
  version = "1.6.68";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    rev = "v${version}";
    sha256 = "1ym16fxx9qhf952vva71sdzgbm7ifis0h1n5fj1bfdj8zvvkbw5w";
  };

  # Fix freaky dos-style CLRF things
  prePatch = ''
    dos2unix CMakeLists.txt
  '';

  patches = [
    # fix build with gcc 13
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/opencollada/files/opencollada-1.6.68-gcc13.patch?id=b76590f9fb8615da3da9d783ad841c0e3881a27b";
      hash = "sha256-oi/QhNPRnuSHfJJ071/3wnjLeg4zZUL6NwSGYvgkb/k=";
    })

    # fix pcre
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/opencollada/files/opencollada-1.6.63-pcre-fix.patch";
      hash = "sha256-igrwgmNwDKYwj6xWvWrryT5ARWJpztVmlQ0HCLQn5+Q=";
    })

    # fix build with cmake 4
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/opencollada/files/opencollada-1.6.68-cmake4.patch?id=42f1e0614c4d056841fdc162c29a04ff0e910139";
      hash = "sha256-gbF6PPalJGgXGu4W7EptYeDq8418JdGH50LIqKqGKX0=";
    })
  ];

  postPatch = ''
    # Drop blanket -Werror as it tends to fail on newer toolchain for
    # minor warnings. In this case it was gcc-13 build failure.
    substituteInPlace DAEValidator/CMakeLists.txt --replace-fail ' -Werror"' '"'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace GeneratedSaxParser/src/GeneratedSaxParserUtils.cpp \
      --replace math.h cmath
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    dos2unix
  ];

  propagatedBuildInputs = [
    libxml2
    pcre
  ];

  meta = {
    description = "Library for handling the COLLADA file format";
    homepage = "https://github.com/KhronosGroup/OpenCOLLADA/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}

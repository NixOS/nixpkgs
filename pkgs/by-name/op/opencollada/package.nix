{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, pkg-config, libxml2, pcre
, darwin}:

stdenv.mkDerivation rec {
  pname = "opencollada";

  version = "1.6.68";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    rev = "v${version}";
    sha256 = "1ym16fxx9qhf952vva71sdzgbm7ifis0h1n5fj1bfdj8zvvkbw5w";
  };

  patches = [
    ./pcre.patch

    # fix build with gcc 13
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/opencollada/files/opencollada-1.6.68-gcc13.patch?id=b76590f9fb8615da3da9d783ad841c0e3881a27b";
      hash = "sha256-uimeLGHgXaFi61mmoaloJ5vo83c8EIQmtHEMngC2Nq4=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ AGL ]);

  propagatedBuildInputs = [ libxml2 pcre ];

  postPatch = ''
    # Drop blanket -Werror as it tends to fail on newer toolchain for
    # minor warnings. In this case it was gcc-13 build failure.
    substituteInPlace DAEValidator/CMakeLists.txt --replace-fail ' -Werror"' '"'
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace GeneratedSaxParser/src/GeneratedSaxParserUtils.cpp \
      --replace math.h cmath
  '';

  meta = {
    description = "Library for handling the COLLADA file format";
    homepage = "https://github.com/KhronosGroup/OpenCOLLADA/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}

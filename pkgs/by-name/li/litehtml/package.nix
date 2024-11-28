{ lib
, stdenv
, fetchFromGitHub
, cmake
, gumbo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "litehtml";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "litehtml";
    repo = "litehtml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZE/HKzo3ejKpW/ih3sJwn2hzCtsBhAXeJWGezYd6Yc4";
  };

  # Don't search for non-existant gumbo cmake config
  # This will mislead cmake that litehtml is not found
  # Affects build of pkgs that depend on litehtml
  postPatch = ''
    substituteInPlace cmake/litehtmlConfig.cmake \
      --replace-fail "find_dependency(gumbo)" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gumbo
  ];

  cmakeFlags = [
    "-DEXTERNAL_GUMBO=ON"
    # BuildTesting need to download test data online
    "-DLITEHTML_BUILD_TESTING=OFF"
  ];

  meta = with lib; {
    description = "Fast and lightweight HTML/CSS rendering engine";
    homepage = "http://www.litehtml.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
})

{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pcre,
  zlib,
  python3,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcms";
  version = "2.0.0.beta2";

  src = fetchurl {
    url = "mirror://sourceforge/cppcms/cppcms-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-aXAxx9FB/dIVxr5QkLZuIQamO7PlLwnugSDo78bAiiE=";
  };

  postPatch = ''
    substituteInPlace {,booster/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    pcre
    zlib
    openssl
  ];

  strictDeps = true;

  cmakeFlags = [
    "--no-warn-unused-cli"
  ];

  meta = {
    homepage = "http://cppcms.com";
    description = "High Performance C++ Web Framework";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})

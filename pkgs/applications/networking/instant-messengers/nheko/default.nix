{
  lib, stdenv, fetchFromGitHub, fetchurl,
  cmake, doxygen, lmdb, qt5, qtmacextras
}:

let
  json_hpp = fetchurl {
    url = https://github.com/nlohmann/json/releases/download/v3.1.2/json.hpp;
    sha256 = "fbdfec4b4cf63b3b565d09f87e6c3c183bdd45c5be1864d3fcb338f6f02c1733";
  };

  variant_hpp = fetchurl {
    url = https://github.com/mpark/variant/releases/download/v1.3.0/variant.hpp;
    sha256 = "1vjiz1x5l8ynqqyb5l9mlrzgps526v45hbmwjilv4brgyi5445fq";
  };

  matrix-structs = stdenv.mkDerivation rec {
    name = "matrix-structs-git";

    src = fetchFromGitHub {
      owner = "mujx";
      repo = "matrix-structs";
      rev = "5e57c2385a79b6629d1998fec4a7c0baee23555e";
      sha256 = "112b7gnvr04g1ak7fnc7ch7w2n825j4qkw0jb49xx06ag93nb6m6";
    };

    postUnpack = ''
      cp ${json_hpp} "$sourceRoot/include/json.hpp"
      cp ${variant_hpp} "$sourceRoot/include/variant.hpp"
    '';

    patches = [ ./fetchurls.patch ];

    nativeBuildInputs = [ cmake doxygen ];
  };

  tweeny = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "b94ce07cfb02a0eb8ac8aaf66137dabdaea857cf";
    sha256 = "1wyyq0j7dhjd6qgvnh3knr70li47hmf5394yznkv9b1indqjx4mi";
  };

  lmdbxx = fetchFromGitHub {
    owner = "bendiken";
    repo = "lmdbxx";
    rev = "0b43ca87d8cfabba392dfe884eb1edb83874de02";
    sha256 = "1whsc5cybf9rmgyaj6qjji03fv5jbgcgygp956s3835b9f9cjg1n";
  };
in
stdenv.mkDerivation rec {
  name = "nheko-${version}";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mujx";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "0qjia42nam3hj835k2jb5b6j6n56rdkb8rn67yqf45xdz8ypmbmv";
  };

  # This patch is likely not strictly speaking needed, but will help detect when
  # a dependency is updated, so that the fetches up there can be updated too
  patches = [ ./external-deps.patch ];

  # If, on Darwin, you encounter the error
  #   error: must specify at least one argument for '...' parameter of variadic
  #   macro [-Werror,-Wgnu-zero-variadic-macro-arguments]
  # Then adding this parameter is likely the fix you want.
  #
  # However, it looks like either cmake doesn't honor this CFLAGS variable, or
  # darwin's compiler doesn't have the same syntax as gcc for turning off
  # -Werror selectively.
  #
  # Anyway, this is something that will have to be debugged with access to a
  # darwin-based OS. Sorry about that!
  #
  #preConfigure = lib.optionalString stdenv.isDarwin ''
  #  export CFLAGS=-Wno-error=gnu-zero-variadic-macro-arguments
  #'';

  cmakeFlags = [
    "-DMATRIX_STRUCTS_LIBRARY=${matrix-structs}/lib/static/libmatrix_structs.a"
    "-DMATRIX_STRUCTS_INCLUDE_DIR=${matrix-structs}/include/matrix_structs"
    "-DTWEENY_INCLUDE_DIR=${tweeny}/include"
    "-DLMDBXX_INCLUDE_DIR=${lmdbxx}"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lmdb lmdbxx matrix-structs qt5.qtbase qt5.qtmultimedia qt5.qttools tweeny
  ] ++ lib.optional stdenv.isDarwin qtmacextras;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}

{ stdenv, fetchFromGitHub, fetchurl, cmake, doxygen, lmdb, qt5 }:

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
      rev = "91bb2b85a75d664007ef81aeb500d35268425922";
      sha256 = "1v544pv18sd91gdrhbk0nm54fggprsvwwrkjmxa59jrvhwdk7rsx";
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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mujx";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "178z64vkl7nmr1amgsgvdcwipj8czp7vbvidxllxiwal21yvqpky";
  };

  # This patch is likely not strictly speaking needed, but will help detect when
  # a dependency is updated, so that the fetches up there can be updated too
  patches = [ ./external-deps.patch ];

  cmakeFlags = [
    "-DMATRIX_STRUCTS_LIBRARY=${matrix-structs}/lib/static/libmatrix_structs.a"
    "-DMATRIX_STRUCTS_INCLUDE_DIR=${matrix-structs}/include/matrix_structs"
    "-DTWEENY_INCLUDE_DIR=${tweeny}/include"
    "-DLMDBXX_INCLUDE_DIR=${lmdbxx}"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lmdb lmdbxx matrix-structs qt5.qtbase qt5.qtmultimedia qt5.qttools tweeny
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.all;
  };
}

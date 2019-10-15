{ lib, stdenv, fetchFromGitHub
, cmake, cmark, lmdb, mkDerivation, qtbase, qtmacextras
, qtmultimedia, qttools, mtxclient, boost, spdlog, olm, pkgconfig
, nlohmann_json
}:

# These hashes and revisions are based on those from here:
# https://github.com/Nheko-Reborn/nheko/blob/v0.6.4/deps/CMakeLists.txt#L52
let
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
mkDerivation rec {
  pname = "nheko";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "19dkc98l1q4070v6mli4ybqn0ip0za607w39hjf0x8rqdxq45iwm";
  };

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

  postPatch = ''
    mkdir -p .deps/include/
    ln -s ${tweeny}/include .deps/include/tweeny
    ln -s ${spdlog} .deps/spdlog
  '';

  cmakeFlags = [
    "-DTWEENY_INCLUDE_DIR=.deps/include"
    "-DLMDBXX_INCLUDE_DIR=${lmdbxx}"
    "-Dnlohmann_json_DIR=${nlohmann_json}/lib/cmake/nlohmann_json"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    mtxclient olm boost lmdb spdlog cmark
    qtbase qtmultimedia qttools
  ] ++ lib.optional stdenv.isDarwin qtmacextras;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = https://github.com/Nheko-Reborn/nheko;
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}

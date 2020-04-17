{ lib
, stdenv
, fetchFromGitHub
, cmake
, cmark
, lmdb
, lmdbxx
, tweeny
, mkDerivation
, qtbase
, qtmacextras
, qtmultimedia
, qttools
, mtxclient
, boost
, spdlog
, olm
, pkgconfig
, nlohmann_json
}:

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

  nativeBuildInputs = [
    lmdbxx
    cmake
    pkgconfig
  ];

  buildInputs = [
    nlohmann_json
    tweeny
    mtxclient
    olm
    boost
    lmdb
    spdlog
    cmark
    qtbase
    qtmultimedia
    qttools
  ] ++ lib.optional stdenv.isDarwin qtmacextras;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}

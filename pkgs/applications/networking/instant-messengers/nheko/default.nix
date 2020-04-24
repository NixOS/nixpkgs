{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, qtquickcontrols2
, qtgraphicaleffects
, mtxclient
, boost17x
, spdlog
, olm
, pkgconfig
, nlohmann_json
}:

mkDerivation rec {
  pname = "nheko";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "12sxibbrn79sxkf9jrm7jrlj7l5vz15claxrrll7pkv9mv44wady";
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
  cmakeFlags = [
    # Can be removed once either https://github.com/NixOS/nixpkgs/pull/85254 or
    # https://github.com/NixOS/nixpkgs/pull/73940 are merged
    "-DBoost_NO_BOOST_CMAKE=TRUE"
  ];
  # commit missing from latest release and recommended by upstream:
  # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619263903
  patches = [
    (fetchpatch {
      name = "room-ids-escape-patch";
      url = "https://github.com/Nheko-Reborn/nheko/commit/d94ac86816f9f325cba11f71344a3ca99591130d.patch";
      sha256 = "1p0kj4a60l3jf0rfakc88adld7ccg3vfjhzia5rf2i03h35cxw8c";
    })
  ];

  buildInputs = [
    nlohmann_json
    tweeny
    mtxclient
    olm
    boost17x
    lmdb
    spdlog
    cmark
    qtbase
    qtmultimedia
    qttools
    qtquickcontrols2
    qtgraphicaleffects
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

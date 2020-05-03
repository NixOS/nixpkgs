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

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.targetPlatform.isDarwin;
    license = licenses.gpl3Plus;
  };
}

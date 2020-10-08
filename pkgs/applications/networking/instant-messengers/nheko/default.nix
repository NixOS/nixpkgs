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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    sha256 = "1cbhgaf9klgxdirrxj571fqwspm0byl75c1xc40l727a6qswvp7s";
  };

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

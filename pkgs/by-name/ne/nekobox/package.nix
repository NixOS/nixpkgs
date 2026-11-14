{
 pkgconfig ? import <nixpkgs> {}.pkgconfig
, automake ? import <nixpkgs> {}.automake
, autoconf ? import <nixpkgs> {}.autoconf
, libtool ? import <nixpkgs> {}.libtool
, lib ? import <nixpkgs> {}.lib
, bash ? import <nixpkgs> {}.bash
, makeWrapper ? import <nixpkgs> {}.makeWrapper
, pkgs ? import <nixpkgs> {}
}:

pkgs.stdenv.mkDerivation rec {
  pname = "nekobox";
  version = "5.10.29";

  src = pkgs.fetchurl {
    url = "https://github.com/qr243vbi/nekobox/releases/download/5.10.29/nekobox-unified-source-5.10.29.tar.xz";
    sha256 = "9fa7c21aeb4e62b6a9eda1bfdea9eb24d8448c7cda56c0e0010e93558f48514a";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pkgs.qt6.qtbase
    pkgs.qt6.qtdeclarative
    pkgs.qt6.qtsvg
    pkgs.qt6.qttools
    pkgs.thrift
    pkgs.pkg-config
    pkgs.go
    pkgs.boost
    pkgs.acl
  ];

  GOFLAGS = "-modcacherw -mod=vendor";
  CGO_ENABLED = "1";

  preBuild = ''
    export HOME=$TMPDIR
    export GOTOOLCHAIN=local
    export GOCACHE=$TMPDIR/go-cache
    export GOMODCACHE=$TMPDIR/go-mod-cache

    mkdir -p "$GOCACHE" "$GOMODCACHE"
  '';

#  configurePhase = ''
#  '';

#  buildPhase = ''
#  '';

#  installPhase = ''
#  '';

  meta = with pkgs.lib; {
    description = "NyameBox, The Original NekoBox Rebranded, the cross-platform Qt proxy utility, empowered by sing-box and thrift";
    homepage = "https://github.com/qr243vbi/nekobox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ "qr243vbi" ];
    mainProgram = "nekobox";
    platforms = lib.platforms.linux;
  };
}

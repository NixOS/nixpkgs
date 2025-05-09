{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  autoreconfHook,
  pkg-config,
  python3,
  fuse,
  glib,
  libarchive,
  libargon2,
  libevent,
  libjwt,
  libmysqlclient,
  libsearpc,
  libuuid,
  openssl,
  sqlite,
  vala,
  which,
  oniguruma,
  nixosTests,
}:

let
  # seafile-server relies on a specific version of libevhtp.
  # It contains non upstreamed patches and is forked off an outdated version.
  libevhtp = import ./libevhtp.nix {
    inherit
      stdenv
      lib
      fetchFromGitHub
      cmake
      libevent
      ;
  };
in
stdenv.mkDerivation {
  pname = "seafile-server";
  version = "12.0.11";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "fde8864542082f00957a2bb82cbe184a49c39161"; # using a fixed revision because upstream may re-tag releases :/
    hash = "sha256-FJBlNu6vZswN7Rk+14rZuoU+EmeWLwbgj3vrpjBtrBk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    libsearpc # searpc-codegen.py
    vala # valac
    which
  ];

  buildInputs = [
    fuse
    glib
    libarchive
    libjwt
    libargon2
    libevent
    libevhtp
    libjwt
    libmysqlclient
    libsearpc
    libuuid
    oniguruma
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/share/seafile/sql
    cp -r scripts/sql $out/share/seafile
  '';

  passthru.tests = {
    inherit (nixosTests) seafile;
  };

  meta = with lib; {
    description = "File syncing and sharing software with file encryption and group sharing, emphasis on reliability and high performance";
    homepage = "https://github.com/haiwen/seafile-server";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      greizgh
      schmittlauch
      melvyn2
    ];
    mainProgram = "seaf-server";
  };
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  python3,
  autoreconfHook,
  libuuid,
  libmysqlclient,
  sqlite,
  glib,
  libevent,
  libsearpc,
  openssl,
  fuse,
  libarchive,
  libjwt,
  curl,
  which,
  vala,
  cmake,
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
  version = "11.0.12"; # Doc links match Seafile 11.0 in seafile.nix – update if version changes.
  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "5e6c0974e6abe5d92b8ba1db41c6ddbc1029f2d5"; # using a fixed revision because upstream may re-tag releases :/
    hash = "sha256-BVa4QZiHPkqRB5FvDlCSbEVxdnyxVy2KuCDb2orRMuI=";
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
    libuuid
    libmysqlclient
    sqlite
    glib
    libsearpc
    libevent
    python3
    fuse
    libarchive
    libjwt
    libevhtp
    oniguruma
  ];

  patches = [
    # https://github.com/haiwen/seafile-server/pull/658
    (fetchpatch {
      url = "https://github.com/haiwen/seafile-server/commit/8029a11a731bfe142af43f230f47b93811ebaaaa.patch";
      hash = "sha256-AWNDXIyrKXgqgq3p0m8+s3YH8dKxWnf7uEMYzSsjmX4=";
    })
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
      melvyn2
    ];
    mainProgram = "seaf-server";
  };
}

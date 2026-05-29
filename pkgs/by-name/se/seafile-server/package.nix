{
  stdenv,
  lib,
  callPackage,
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
  libargon2,
  curl,
  which,
  vala,
  oniguruma,
  hiredis,
  jansson,
  nixosTests,
}:

let
  # seafile-server requires a specific haiwen fork of libevhtp that contains
  # patches not upstreamed to the original project.
  libevhtp = callPackage ./libevhtp.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "seafile-server";
  version = "13.0.21";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    # Using a fixed revision because upstream may re-tag releases.
    rev = "f0e82f8fb79b6edf8abb49d4cfd46f8029cbdffe";
    hash = "sha256-ce6GjykzoQ4F+nP3hMuR606Ut2oIDXCvHGMQD+z6m54=";
  };

  # clang 15+ and GCC 14+ treat incompatible function pointer casts in the
  # evhtp callback API as errors
  env.NIX_CFLAGS_COMPILE = "-std=gnu17 -Wno-incompatible-function-pointer-types";

  patches = [
    # seaf_delete_repo_tokens declared in seaf-utils.h but not included in fsck.c.
    (fetchpatch {
      url = "https://github.com/haiwen/seafile-server/commit/a04c027917c0f5efbb12bec563ec5469c7d3eb86.patch";
      hash = "sha256-+d0g8xkeB99qV+Kfuk64nefHzCJzL8xrf05k2Eg73xA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    libsearpc
    vala
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
    libargon2
    libevhtp
    oniguruma
    hiredis
    jansson
    curl
    openssl
  ];

  postPatch = ''
    # lib/Makefile.am has a BSD-sed in-place call; replace with GNU sed syntax
    substituteInPlace lib/Makefile.am \
      --replace-fail "sed -i ''' -e" "sed -i -e"
  '';

  postInstall = ''
    mkdir -p $out/share/seafile/sql
    cp -r scripts/sql $out/share/seafile
  '';

  passthru.tests = {
    inherit (nixosTests) seafile;
  };

  meta = {
    description = "File syncing and sharing software with file encryption and group sharing";
    homepage = "https://github.com/haiwen/seafile-server";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "seaf-server";
  };
})

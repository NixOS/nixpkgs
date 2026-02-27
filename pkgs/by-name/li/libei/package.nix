{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  libevdev,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  protobuf,
  protobufc,
  systemd,
  buildPackages,
  epoll-shim,
  basu,
  evdev-proto,
}:
let
  munit = fetchFromGitHub {
    owner = "nemequ";
    repo = "munit";
    rev = "fbbdf1467eb0d04a6ee465def2e529e4c87f2118";
    hash = "sha256-qm30C++rpLtxBhOABBzo+6WILSpKz2ibvUvoe8ku4ow=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libei";
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libei";
    rev = finalAttrs.version;
    hash = "sha256-PqQpJz88tDzjwsBuwxpWcGAWz6Gp6A/oAOS87uxGOGs=";
  };

  patches = lib.optionals stdenv.hostPlatform.isBSD [
    # From https://gitlab.freedesktop.org/libinput/libei/-/merge_requests/357
    (fetchpatch {
      name = "peercred-bsd.patch";
      url = "https://gitlab.freedesktop.org/libinput/libei/-/commit/4f11112be0c0a89e8f078c0b4bcc103dbc6ac875.patch";
      hash = "sha256-Z6oZphzyfHMdAQninbUvEtxr738sx/SQV8o0fkF25iI=";
    })
  ];

  buildInputs = [
    libevdev
    libxkbcommon
    protobuf
    protobufc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemd
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    basu
    epoll-shim
    evdev-proto
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (buildPackages.python3.withPackages (
      ps: with ps; [
        attrs
        jinja2
        pytest
        python-dbusmock
        strenum
        structlog
      ]
    ))
  ];

  mesonFlags = lib.optionals stdenv.hostPlatform.isFreeBSD [
    "-Dsd-bus-provider=basu"
  ];

  postPatch = ''
    ln -s "${munit}" ./subprojects/munit
    patchShebangs ./proto/ei-scanner
  '';

  meta = {
    description = "Library for Emulated Input";
    mainProgram = "ei-debug-events";
    homepage = "https://gitlab.freedesktop.org/libinput/libei";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pedrohlc ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})

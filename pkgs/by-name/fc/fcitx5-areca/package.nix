{
  lib,
  stdenv,
  cmake,
  dbus,
  fcitx5,
  fetchFromGitHub,
  fontconfig,
  go,
  libinput,
  ninja,
  nix-update-script,
  pkg-config,
  sdl3,
  udev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-areca";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "xhkzeroone";
    repo = "ArecaIME";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ud7dwE912TN8z3CWtzuVxygYAB4xV5mBo83SyrUUt+0=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    go
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    fcitx5
    fontconfig
    libinput
    sdl3
    udev
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=off
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vietnamese input method addon for Fcitx5";
    homepage = "https://github.com/xhkzeroone/ArecaIME";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justanoobcoder ];
    platforms = lib.platforms.linux;
  };
})

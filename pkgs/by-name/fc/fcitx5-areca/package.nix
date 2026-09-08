{
  lib,
  stdenv,
  cmake,
  dbus,
  fcitx5,
  fetchFromGitHub,
  go,
  pkg-config,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-areca";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "xhkzeroone";
    repo = "ArecaIME";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KVcvIYeDgsstRJ3OaXv1EhjCZA0cfae8H1/uVktY6DA=";
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

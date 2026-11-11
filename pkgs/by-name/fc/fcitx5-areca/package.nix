{
  lib,
  stdenv,
  cmake,
  fcitx5,
  fetchFromGitHub,
  go,
  pkg-config,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-areca";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "xhkzeroone";
    repo = "ArecaIME";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tjNKRU3yTIOGxkpE2RSuTa7lLZtQvFcUQ0ELCQyinVc=";
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

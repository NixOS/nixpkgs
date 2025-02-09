{
  lib,
  stdenv,

  fetchFromGitHub,

  pkgsCross,
  pkg-config,
  glib,

  alsa-lib,
  gtk3,

  oscmix,
  unstableGitUpdater,

  alsaSupport ? stdenv.hostPlatform.isLinux,
  gtkSupport ? false,
  enableWebui ? false,
}:

stdenv.mkDerivation {
  pname = "oscmix";
  version = "0-unstable-2025-02-05";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "oscmix";
    rev = "ba5e58d4169096f89806794ba1e0caf82ee660ee";
    hash = "sha256-ONPFFuQa2xjD8PlupsLY6xZ4U6s0D27mTqNrvei9VQs=";
  };

  nativeBuildInputs =
    lib.optionals (alsaSupport || gtkSupport) [ pkg-config ]
    ++ lib.optionals (gtkSupport) [ glib ]
    ++ lib.optionals (enableWebui) [ pkgsCross.wasi32.stdenv.cc.bintools ];

  buildInputs = lib.optionals alsaSupport [ alsa-lib ] ++ lib.optionals gtkSupport [ gtk3 ];

  makeFlags =
    let
      option = bool: if bool then "y" else "n";
    in
    [
      "ALSA=${option alsaSupport}"
      "GTK=${option gtkSupport}"
      "WEB=${option enableWebui}"
    ]
    ++ lib.optionals (enableWebui) [
      "WASM_CC=${lib.getExe pkgsCross.wasi32.stdenv.cc}"
    ];

  installFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ];

  passthru = {
    tests = {
      oscmix-gtk = oscmix.override { gtkSupport = true; };
      oscmix-web = oscmix.override { enableWebui = true; };
    };

    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Open Sound Control API for RME Fireface UCX II";
    homepage = "https://github.com/michaelforney/oscmix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = if alsaSupport then lib.platforms.linux else lib.platforms.all;
  };
}

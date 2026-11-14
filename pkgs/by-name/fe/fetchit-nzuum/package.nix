{
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  lua5_4,
  vulkan-tools,
  pciutils,
  mesa-demos,
  makeWrapper,
  lib,
  gnugrep,
}:

stdenv.mkDerivation {
  pname = "fetchit";
  version = "0-unstable-2026-08-12";

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Minimal system info fetcher written in C and configurable in lua";
    homepage = "https://codeberg.org/nzuum/fetchit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ agnab ];
    platforms = lib.platforms.linux;
    mainProgram = "fetchit";
  };

  src = fetchFromCodeberg {
    owner = "nzuum";
    repo = "fetchit";
    rev = "da3f5cf58fb2807cf3ae2f2cf4cd65c18e685bd7";
    hash = "sha256-gT+zfJjFxgZcXlCR3crD4QuZlrb5Z9psvdUtAYUTHEo=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    lua5_4
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/fetchit \
      --set PATH ${
        lib.makeBinPath [
          vulkan-tools
          pciutils
          mesa-demos
          gnugrep
        ]
      }
  '';
}

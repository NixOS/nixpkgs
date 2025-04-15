{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  pkg-config,
  cmake,
  fontconfig,
  libGL,
  xorg,
  libxkbcommon,
  wayland,
  # Darwin Frameworks
  AppKit,
  CoreGraphics,
  CoreServices,
  CoreText,
  Foundation,
  libiconv,
  OpenGL,
}:

let
  rpathLibs =
    [
      fontconfig
      libGL
      xorg.libxcb
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libxkbcommon
      wayland
    ];
in
rustPlatform.buildRustPackage rec {
  pname = "slint-lsp";
  version = "1.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5LDEjJx+PC6pOem06DKFkPcjpIkF20gbxi/PAVZT1ns=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1/4dOlhByJDpduExu9ZOjb7JYFKehnLiLCboWUnmfp8=";

  nativeBuildInputs = [
    cmake
    pkg-config
    fontconfig
  ];
  buildInputs =
    rpathLibs
    ++ [ xorg.libxcb.dev ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      CoreGraphics
      CoreServices
      CoreText
      Foundation
      libiconv
      OpenGL
    ];

  # Tests requires `i_slint_backend_testing` which is only a dev dependency
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath ${lib.makeLibraryPath rpathLibs} $out/bin/slint-lsp
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Slint UI language";
    mainProgram = "slint-lsp";
    homepage = "https://slint-ui.com/";
    changelog = "https://github.com/slint-ui/slint/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ xgroleau ];
  };
}

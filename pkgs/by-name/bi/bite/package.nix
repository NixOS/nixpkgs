{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libxkbcommon,
  pango,
  vulkan-loader,
  stdenv,
  darwin,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "bite";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "WINSDK";
    repo = "bite";
    rev = "V${version}";
    hash = "sha256-A5NII5pLnM4BBy2L+ylXU0anqw4DpKgXmc29fcTq2z8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libc-0.2.140" = "sha256-5cP25BDfkrybiZjmwmzeqd0nzdItFdNSZ4te7FdLpnk=";
      "nix-0.26.1" = "sha256-AsOX8sLGHJNJhq0P9WDxWsNiRXgZJl15paTcGdPMQXA=";
      "pdb-0.8.0" = "sha256-CEglHzBpS3rN7+05tS09FbBcOM0jjyvR+DWrEbvRYwE=";
      "tree-sitter-c-0.21.0" = "sha256-7L3Ua6LBeX2492RTikKYeCNIG5e5XSrCu4UyXX1eQiI=";
      "tree-sitter-cpp-0.21.0" = "sha256-WZy3S8+bRkpzUFpnLVp18rY5DxN70fdEPYIYx0UqJhs=";
      "tree-sitter-rust-0.21.0" = "sha256-kZT4Hil7u4GFWImuQCt9nQJ+HL3B5yHD5wjalpDLlSE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    copyDesktopItems
    imagemagick
  ];

  buildInputs =
    [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      libxkbcommon
      pango
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.QuartzCore
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wayland
    ];

  runtimeDependencies =
    [
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wayland
    ];

  postInstall = ''
    wrapProgram $out/bin/bite \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}"

    mkdir -p $out/share/icons/hicolor/64x64/apps
    convert $src/assets/iconx64.png -background black -alpha remove -alpha off $out/share/icons/hicolor/64x64/apps/bite.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "BiTE";
      exec = meta.mainProgram;
      icon = "bite";
      desktopName = "BiTE";
      comment = meta.description;
      categories = ["Development" "Utility"];
    })
  ];

  meta = with lib; {
    description = "Disassembler focused on comprehensive rust support";
    homepage = "https://github.com/WINSDK/bite";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
    mainProgram = "bite";
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  darwin,
  wayland,
  cargo-about,
  makeDesktopItem,
  dav1d,
  libheif,
}:

rustPlatform.buildRustPackage rec {
  pname = "simp";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "Kl4rry";
    repo = "simp";
    rev = "v${version}";
    hash = "sha256-NALVHcU+NhCT5w+pn6WhP+cFGPuDhnPt+IDNHN/oqls=";
  };

  cargoHash = "sha256-Wp50ldXGy7MLQTnvZDx3LIr8jLBpkoCrh0/xPowIn54=";

  nativeBuildInputs = [
    autoPatchelfHook
    cargo-about
  ];

  buildInputs =
    [ stdenv.cc.cc.lib ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.QuartzCore
    ];

  desktopItems = [
    (makeDesktopItem {
      name = "simp";
      desktopName = "simp";
      genericName = "Image Editor";
      exec = "simp %U";
      icon = "icon";
      categories = [ "Graphics" ];
      mimeTypes = [ "image/bmp" ];
    })
  ];

  preBuild = ''
    # replace variable from git cmd output
    sed -i '35,39c let git_hash=String::from("${version}");' build.rs
  '';

  appendRunpaths = [
    (lib.makeLibraryPath (
      [
        dav1d
        libheif
        libxkbcommon
        vulkan-loader
      ]
      ++ lib.optionals stdenv.isLinux [ wayland ]
    ))
  ];
  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    install -Dm644 -t $out/share/icons/hicolor/256x256/apps/ $src/icon.png
  '';

  meta = {
    description = "Fast and simple GPU-accelerated image manipulation program";
    homepage = "https://github.com/Kl4rry/simp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "simp";
  };
}

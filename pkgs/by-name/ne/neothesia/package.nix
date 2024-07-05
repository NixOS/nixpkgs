{ rustPlatform
, fetchFromGitHub
, lib
, ffmpeg
, pkg-config
, alsa-lib
, wayland
, makeWrapper
, llvmPackages
, libxkbcommon
, vulkan-loader
, xorg
}:
let
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "PolyMeilex";
    repo = "Neothesia";
    rev = "v${version}";
    hash = "sha256-bQ2546q+oachvuNKMJHjQzF6uv06LG+f7eFQPoAn6mw=";
  };
in
rustPlatform.buildRustPackage {
  pname = "neothesia";

  inherit src version;

  buildInputs = [
    ffmpeg
    alsa-lib
  ];

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
    makeWrapper
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mpeg_encoder-0.2.1" = "sha256-+BNZZ1FIr1374n8Zs1mww2w3eWHOH6ENOTYXz9RT2Ck=";
    };
  };

  cargoBuildFlags = [
    "-p neothesia -p neothesia-cli"
  ];

  postInstall = ''
    wrapProgram $out/bin/neothesia --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland libxkbcommon vulkan-loader xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrender ]}"
    install -Dm 644 flatpak/com.github.polymeilex.neothesia.desktop $out/share/applications/com.github.polymeilex.neothesia.desktop
  '';

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  meta = {
    description = "Flashy Synthesia Like Software For Linux, Windows and macOS";
    homepage = "https://github.com/PolyMeilex/Neothesia";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "neothesia";
    maintainers = [
      lib.maintainers.naxdy
    ];
  };
}

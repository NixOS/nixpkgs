{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  kakoune,
  makeWrapper,
  testers,
  withGui ? false,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  fontconfig,
  freetype,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kasane";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Yus314";
    repo = "kasane";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vc7gG9xHaKujv7jb2Gn+NDpRaQPDpNLa4e7dr79LbFI=";
  };

  cargoHash = "sha256-GLl/7PHmsN3cqqTbkN/wFgccQsuV8vqg4iSxh3ihXw4=";

  cargoBuildFlags = [
    "-p"
    "kasane"
  ];
  buildFeatures = lib.optionals withGui [ "gui" ];

  doCheck = true;
  cargoTestFlags = [
    "-p"
    "kasane-core"
    "-p"
    "kasane-tui"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals (withGui && stdenv.hostPlatform.isLinux) [
    vulkan-loader
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXcursor
    libXrandr
    libXi
    fontconfig
    freetype
  ];

  postInstall =
    let
      wrapArgs = lib.concatStringsSep " " (
        [
          "--prefix PATH : ${lib.makeBinPath [ kakoune ]}"
        ]
        ++ lib.optionals (withGui && stdenv.hostPlatform.isLinux) [
          "--prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              vulkan-loader
              wayland
              libxkbcommon
            ]
          }"
        ]
      );
    in
    ''
      wrapProgram $out/bin/kasane ${wrapArgs}
    '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Alternative frontend for the Kakoune text editor";
    homepage = "https://github.com/Yus314/kasane";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ yus314 ];
    mainProgram = "kasane";
  };
})

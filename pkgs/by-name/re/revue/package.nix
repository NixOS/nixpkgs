{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  cmake,
  clang,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  wayland,
  libxkbcommon,
  libxcb,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  vulkan-loader,
  libGL,
  fontconfig,
  freetype,
  zstd,
  git,
}:

let
  # Loaded with dlopen at runtime by GPUI.
  runtimeLibs = [
    wayland
    libxkbcommon
    libxcb
    libx11
    libxcursor
    libxrandr
    libxi
    vulkan-loader
    libGL
    fontconfig
    freetype
    zstd
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "revue";
  version = "0.42.0";

  src = fetchFromGitea {
    domain = "forgejo.cleangame.dev";
    owner = "thatrichan";
    repo = "revue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/6d7T1vxJFkOCdDOHrB3m9PNL6oxkqxquKSEgZxQx8w=";
  };

  cargoHash = "sha256-x+iUuFZDKTQpUGaQtdS01tV+0fhI3YeLlG6w0CykwNo=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    clang
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = runtimeLibs;

  env.LIBCLANG_PATH = "${lib.getLib clang.cc}/lib";

  # The tests drive the GUI.
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "revue";
      desktopName = "Revue";
      comment = "Fast native code review";
      exec = "revue %U";
      icon = "revue";
      categories = [ "Development" ];
      startupWMClass = "revue";
    })
  ];

  postInstall = ''
    for n in 16 24 32 48 64 128 256 512 1024; do
      install -Dm644 assets/icons/revue-$n.png $out/share/icons/hicolor/''${n}x''${n}/apps/revue.png
    done
  '';

  # GPUI opens these with dlopen, and runs git for clones and checkouts.
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/revue
    wrapProgram $out/bin/revue --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native desktop app for reviewing pull requests on GitHub, Bitbucket Cloud and Forgejo";
    homepage = "https://revue.cleangame.dev";
    changelog = "https://forgejo.cleangame.dev/thatrichan/revue/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ that-richan ];
    mainProgram = "revue";
    platforms = lib.platforms.linux;
  };
})

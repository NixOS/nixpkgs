{
  lib,
  fetchFromGitea,
  buildType ? "release",
  platform ? "linux",
  enableWayland ? true,
  enableXorg ? true,
  enableOpenGL ? true,
  enableVulkan ? true,
  rustPlatform,
  makeDesktopItem,
  pkg-config,
  libxkbcommon,
  alsa-lib,
  libGL,
  vulkan-loader,
  wayland,
  libXrandr,
  libXcursor,
  libX11,
  libXi,
  ...
}:

assert (platform == "linux") -> (enableWayland || enableXorg);
assert (platform == "linux") -> (enableVulkan || enableOpenGL);

rustPlatform.buildRustPackage rec {
  pname = "outfly";
  inherit buildType;
  version = "0.10.1";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "outfly";
    repo = "outfly";
    rev = "v${version}";
    hash = "sha256-VmUiDORTlXQvAKNXSQOI4+xqp/uhqBcKGHdzhM+D1pU=";

  };

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "embed_assets"
  ] ++ lib.optionals enableXorg [ "x11" ] ++ lib.optionals enableWayland [ "wayland" ];

  runtimeInputs =
    [ libxkbcommon ]
    ++ lib.optionals enableOpenGL [ libGL ]
    ++ lib.optionals enableXorg [
      libXrandr
      libX11
    ]
    ++ lib.optionals enableVulkan [ vulkan-loader ];

  buildInputs = [
    alsa-lib.dev
    libXcursor
    libXi
  ] ++ lib.optionals enableWayland [ wayland ];

  nativeBuildInputs = [ pkg-config ];
  doCheck = false;

  postFixup = ''
    patchelf $out/bin/outfly \
    --add-rpath ${lib.makeLibraryPath runtimeInputs}
  '';

  cargoHash = "sha256-EbzMPS2udrqVJF3Y2NfNV71Mv9oW8ZepQoP08w62QuY=";

  desktopItems = [
    (makeDesktopItem {
      name = "outfly";
      exec = "outfly";

      desktopName = "OutFly";
      categories = [ "Game" ];
    })
  ];
  meta = {
    description = "A breathtaking 3D space game in the rings of Jupiter";
    homepage = "https://yunicode.itch.io/outfly";
    downloadPage = "https://codeberg.org/outfly/outfly/releases";
    changelog = "https://codeberg.org/outfly/outfly/releases/tag/v${version}";
    license = [ lib.licenses.gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _71rd ];
    mainProgram = "outfly";
  };
}

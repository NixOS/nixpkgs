{
  lib,
  rustPlatform,
  fetchFromGitea,
  makeWrapper,
  cacert,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfait";
  version = "0.4.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7cbJ5HEkGhjIOnIeBEasa5TVurXcSLuOB3rOMLFd+os=";
  };

  nativeBuildInputs = [
    makeWrapper
    cacert # Required for some tests
  ];

  cargoHash = "sha256-2P9ybgIIvG7oaVOkvPaWNYyIMfa9PFlJbnLaGe4IYjc=";
  buildFeatures = [ "gui" ];
  cargoBuildFlags = [
    "--bin"
    "cfait"
    "--bin"
    "gui"
  ];

  outputs = [
    "out"
    "gui"
  ];

  postInstall = ''
    mkdir -p $gui/bin
    mv $out/bin/gui $gui/bin/cfait-gui
    wrapProgram $gui/bin/cfait-gui \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          wayland
          libx11
          libxcursor
          libxi
          libxkbcommon
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CalDAV task manager for power users";
    homepage = "https://codeberg.org/trougnouf/cfait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "cfait";
    platforms = lib.platforms.all;
  };
})

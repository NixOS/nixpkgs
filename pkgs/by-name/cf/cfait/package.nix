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
  version = "0.5.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P4Z6jLHKYczT1/cDGtED69SHFB/g8I2UsUBGBsQva8c=";
  };

  nativeBuildInputs = [
    makeWrapper
    cacert # Required for some tests
  ];

  cargoHash = "sha256-HJd4hhfEsl+lbbI0XhLOylMkdvxJime8lv+9fHkevo0=";
  buildFeatures = [ "gui" ];
  cargoBuildFlags = [
    "--bin"
    "cfait"
    "--bin"
    "gui"
  ];
  # Can be removed in >0.5.1, see https://codeberg.org/trougnouf/cfait/commit/9441df3fb63d4087caa0d9f10b73af6b6f8058ef
  cargoTestFlags = [ "--all-features" ];

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.+)"
    ];
  };

  meta = {
    description = "CalDAV task manager for power users";
    homepage = "https://codeberg.org/trougnouf/cfait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "cfait";
    platforms = lib.platforms.all;
  };
})

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
  version = "1.0.9";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8wbQdCWpyzOjawdp/78cKPiBixhLfU5OBUZvKW0i6yY=";
  };

  nativeBuildInputs = [
    makeWrapper
    cacert # Required for some tests
  ];

  cargoHash = "sha256-wIMrfW2atR64xUd8li+dplK1qQW2tvA+Fim9kf+xAt4=";
  buildFeatures = [ "gui" ];
  cargoBuildFlags = [
    "--bin"
    "cfait"
    "--bin"
    "cfait-gui"
  ];

  outputs = [
    "out"
    "gui"
  ];

  postInstall = ''
    mkdir -p $gui/bin
    mv $out/bin/cfait-gui $gui/bin/cfait-gui
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

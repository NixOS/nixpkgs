{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  autoPatchelfHook,
  darwin,
  fontconfig,
  wayland,
  libxkbcommon,
  libGL,
  libX11,
  libXcursor,
  libXi,
  zenity,
}:
let
  version = "2.0.0";
  commit = "3846a7d315a9d1e3ffaf3f917345ffb225b1b400";
in
rustPlatform.buildRustPackage {
  pname = "objdiff";
  inherit version;

  src = fetchFromGitHub {
    owner = "encounter";
    repo = "objdiff";
    rev = "v${version}";
    hash = "sha256-iheRHnmoX0lXAWL3t7HKN/BbcPyup0euom3Jw3kQlVI=";
  };

  # objdiff-cli doesn't use vergen, but its own bespoke invocation of the git
  # CLI. Remove the entire build script, and provide the data ourselves.
  postPatch = ''
    rm objdiff-cli/build.rs
    substituteInPlace objdiff-cli/Cargo.toml \
      --replace-fail 'build = "build.rs"' ""
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "notify-6.1.1" = "sha256-g1IIpU9Htmv6Gzb70MuSGtji8pGZG6WomyiZfOHSpjA=";
    };
  };

  nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.AppKit ] else [ fontconfig ];

  # Fix: Failed to launch application: WinitEventLoop(RecreationAttempt)
  runtimeDependencies = lib.optionals (!stdenv.isDarwin) [
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXi
  ];

  env = {
    VERGEN_GIT_BRANCH = "master";
    VERGEN_GIT_SHA = commit;
    GIT_COMMIT_SHA = commit;
  };

  # rfd crate using gnome zenity as file picker on linux
  # Fix: pick_folder error No such file or directory (os error 2)
  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/objdiff \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Local diffing tool for decompilation projects";
    homepage = "https://github.com/encounter/objdiff";
    changelog = "https://github.com/encounter/objdiff/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ roblabla ];
    mainProgram = "objdiff";
  };
}

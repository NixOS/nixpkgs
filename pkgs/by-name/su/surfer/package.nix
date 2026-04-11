{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  wayland,
  autoPatchelfHook,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  stdenv,
  makeWrapper,
  zenity,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "surfer";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "surfer-project";
    repo = "surfer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-83UKSD9Z4pT0OXLqIgquuJ8W6+U29ZzWG1SOrAOK9ic=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  # Wayland and X11 libs are required at runtime since winit uses dlopen
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
    libGL
    libx11
    libxcursor
    libxi
  ];

  cargoHash = "sha256-UuZpgW8di79mTNpDJ7K12IC5Xa3YX9ex2BYd62pUh1o=";

  # Avoid the network attempt from skia. See: https://github.com/cargo2nix/cargo2nix/issues/318
  doCheck = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/surfer \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Extensible and Snappy Waveform Viewer";
    homepage = "https://surfer-project.org/";
    changelog = "https://gitlab.com/surfer-project/surfer/-/releases/v${finalAttrs.version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "surfer";
  };
})

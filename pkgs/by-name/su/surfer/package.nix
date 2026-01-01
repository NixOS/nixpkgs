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
  libX11,
  libXcursor,
  libXi,
  stdenv,
  makeWrapper,
  zenity,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "surfer";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "surfer-project";
    repo = "surfer";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-2ikeG4K1CpyHgAZZfPzEFRXRoEh2PnOIf+8OREO6xug=";
=======
    hash = "sha256-rNJIe6FlAQI2B3lsRYHKMIGgJ1Q5EFX7kWgml+sXxtc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    libX11
    libXcursor
    libXi
  ];

<<<<<<< HEAD
  cargoHash = "sha256-E+9u7t6bLzORL2HiG4iT5pT4nGftyOgO2/eXHuQK4pQ=";
=======
  cargoHash = "sha256-Q4SyuBNR7FnBe3h1rUo48Sxk2COdQbECiXXrGpwXhPk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

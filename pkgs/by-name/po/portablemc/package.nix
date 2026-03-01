{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  jre,

  libx11,
  libxext,
  libxcursor,
  libxrandr,
  libxxf86vm,
  libpulseaudio,
  libGL,
  glfw,
  openal,
  udev,

  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
  flite,
}:

let
  # Copied from the `prismlauncher` package
  runtimeLibs = [
    # lwjgl
    libGL
    glfw
    openal
    (lib.getLib stdenv.cc.cc)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxext
    libxcursor
    libxrandr
    libxxf86vm

    # lwjgl
    libpulseaudio

    # oshi
    udev
  ]
  ++ lib.optional textToSpeechSupport flite;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "portablemc";
  version = "4.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindstorm38";
    repo = "portablemc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KE1qf6aIcDjwKzrdKDUmriWfAt+vuriew6ixHKm0xs8=";
  };

  patches = [
    # Use the jre package provided by nixpkgs by default
    ./use-builtin-java.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = [ python3Packages.certifi ];

  # Note: Tests use networking, so we don't run them

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd portablemc \
        --bash <($out/bin/portablemc show completion bash) \
        --zsh <($out/bin/portablemc show completion zsh)
  '';

  preFixup = ''
    makeWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
      --prefix PATH : ${lib.makeBinPath [ jre ]}
    )
  '';

  meta = {
    homepage = "https://github.com/mindstorm38/portablemc";
    description = "Fast, reliable and cross-platform command-line Minecraft launcher and API for developers";
    longDescription = ''
      A fast, reliable and cross-platform command-line Minecraft launcher and API for developers.
      Including fast and easy installation of common mod loaders such as Fabric, Forge, NeoForge and Quilt.
      This launcher is compatible with the standard Minecraft directories.
    '';
    changelog = "https://github.com/mindstorm38/portablemc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    mainProgram = "portablemc";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})

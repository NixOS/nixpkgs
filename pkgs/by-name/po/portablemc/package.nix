{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  jre,

  libX11,
  libXext,
  libXcursor,
  libXrandr,
  libXxf86vm,
  libpulseaudio,
  libGL,
  glfw,
  openal,
  udev,

  textToSpeechSupport ? stdenv.isLinux,
  flite,
}:

let
  # Copied from the `prismlauncher` package
  runtimeLibs = [
    libX11
    libXext
    libXcursor
    libXrandr
    libXxf86vm

    # lwjgl
    libpulseaudio
    libGL
    glfw
    openal
    stdenv.cc.cc.lib

    # oshi
    udev
  ] ++ lib.optional textToSpeechSupport flite;
in
python3Packages.buildPythonApplication rec {
  pname = "portablemc";
  version = "4.3.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mindstorm38";
    repo = "portablemc";
    rev = "v${version}";
    hash = "sha256-jCv4ncXUWbkWlBZr3P1hNeVpdQzY9HtrFz+pmKknL0I=";
  };

  patches = [
    # Use the jre package provided by nixpkgs by default
    ./use-builtin-java.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = [ python3Packages.certifi ];

  # Note: Tests use networking, so we don't run them

  postInstall = ''
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
    changelog = "https://github.com/mindstorm38/portablemc/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Only;
    mainProgram = "portablemc";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

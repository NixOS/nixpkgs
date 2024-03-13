{ lib
, stdenv
, python3
, fetchFromGitHub
, installShellFiles
, jre

, libX11
, libXext
, libXcursor
, libXrandr
, libXxf86vm
, libpulseaudio
, libGL
, glfw
, openal
, udev

, textToSpeechSupport ? stdenv.isLinux
, flite
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
  ]
  ++ lib.optional textToSpeechSupport flite;
in
python3.pkgs.buildPythonApplication rec {
  pname = "portablemc";
  version = "4.2.1";
  pyproject = true;

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mindstorm38";
    repo = "portablemc";
    rev = "v${version}";
    hash = "sha256-62PJ/vaF9+aC2t2t+Z/7LUjSFfc2Rb1g49GZjZGPV0Q=";
  };

  patches = [
    # Use the jre package provided by nixpkgs by default
    ./use-builtin-java.patch
  ];

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    installShellFiles
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
  ];

  postInstall = ''
    installShellCompletion --cmd portablemc \
        --bash <($out/bin/portablemc show completion bash) \
        --zsh <($out/bin/portablemc show completion zsh)
  '';

  dontCheck = true; # Tests use networking

  preFixup = ''
    makeWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
      --prefix PATH : ${lib.makeBinPath [ jre ]}
    )
  '';

  meta = {
    changelog = "https://github.com/mindstorm38/portablemc/releases/tag/${src.rev}";
    description = "A fast, reliable and cross-platform command-line Minecraft launcher and API for developers";
    longDescription = ''
      A fast, reliable and cross-platform command-line Minecraft launcher and API for developers.
      Including fast and easy installation of common mod loaders such as Fabric, Forge, NeoForge and Quilt.
      This launcher is compatible with the standard Minecraft directories.
    '';
    homepage = "https://github.com/mindstorm38/portablemc";
    license = lib.licenses.gpl3Only;
    mainProgram = "portablemc";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  addDriverRunpath,
  jdk17,
  jdk21,
  jdk25,
  jdk8,
  libxcb,

  # Runtime libraries for the JVM/LWJGL child process that rmcl spawns.
  alsa-lib,
  flite,
  glfw3-minecraft,
  libGL,
  libdecor,
  libjack2,
  libpulseaudio,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxxf86vm,
  openal,
  pciutils,
  pipewire,
  udev,
  vulkan-loader,
  wayland,
  xrandr,

  # `javac`/`jar` build the embedded shim jar; `java` launches Minecraft.
  # rmcl resolves the JVM at runtime from JAVA_HOME, then `java` on PATH
  # (i.e. the first entry of `jdks`), and instances may override it via
  # `java-path` in rmcl`s config. rmcl`s Java picker discovers every `java`
  # it finds on PATH, so bundling multiple JDKs makes them all selectable
  # per-instance.
  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
  additionalLibs ? [ ],
  additionalPrograms ? [ ],
}:

let
  runtimeLibs = [
    (lib.getLib stdenv.cc.cc)

    glfw3-minecraft
    openal

    # openal backends
    alsa-lib
    libjack2
    libpulseaudio
    pipewire

    # glfw
    libGL
    libdecor
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxxf86vm
    wayland

    flite # text to speech
    udev # oshi
    vulkan-loader # VulkanMod's lwjgl
  ]
  ++ additionalLibs;

  runtimePrograms = [
    pciutils # lspci
    xrandr # LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
  ]
  ++ additionalPrograms;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmcl";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "objz";
    repo = "rmcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zfzkL5m5QaYv1sOLLjAU/EaMEp1QRAZGgw3V298G1OM=";
  };

  cargoHash = "sha256-C6wicKfU3MAo6Ui2oYQXM5PYkSwlW9MqNdEY5jvDqQ4=";

  # build.rs shells out to javac/jar to compile java/RmclShim.java into a jar
  # that the binary embeds via include_bytes!.
  nativeBuildInputs = [
    (lib.head jdks)
    makeBinaryWrapper
  ];

  buildInputs = [ libxcb ];

  # The suite writes config via dirs-next; $HOME is unwritable in the sandbox.
  preCheck = ''
    export HOME=$(mktemp -d)
    export XDG_CONFIG_HOME=$HOME/.config
  '';

  postInstall = ''
    install -Dm644 README.md $out/share/doc/rmcl/README.md

    wrapProgram $out/bin/rmcl \
      --prefix PATH : ${lib.makeBinPath (jdks ++ runtimePrograms)} \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A minecraft TUI/CLI launcher written in Rust";
    homepage = "https://github.com/objz/rmcl";
    changelog = "https://github.com/objz/rmcl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "rmcl";
    maintainers = with lib.maintainers; [ pltrz ];
    platforms = lib.platforms.linux;
  };
})

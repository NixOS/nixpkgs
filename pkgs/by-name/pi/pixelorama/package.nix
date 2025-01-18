{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  fetchFromGitHub,
  godot_4,
  godot_4-export-templates,
  libGL,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  nix-update-script,
  udev,
  vulkan-loader,
}:

let
  preset =
    if stdenv.isLinux then
      if stdenv.is64bit then "Linux/X11 64-bit" else "Linux/X11 32-bit"
    else if stdenv.isDarwin then
      "Mac OSX"
    else
      throw "unsupported platform";

  godot_version_folder = lib.replaceStrings [ "-" ] [ "." ] godot_4.version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pixelorama";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Orama-Interactive";
    repo = "Pixelorama";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lfim5ZiykOhI1kgsu0ni2frUVHPRIPJdrGx6TuUQcSY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    godot_4
  ];

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libGL
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXi
    libXrandr
    udev
    vulkan-loader
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/export_templates
    ln -s "${godot_4-export-templates}" "$HOME/.local/share/godot/export_templates/${godot_version_folder}"
    mkdir -p build
    godot4 --headless --export-release "${preset}" ./build/pixelorama

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/pixelorama
    install -D -m 644 -t $out/libexec ./build/pixelorama.pck
    install -D -m 644 -t $out/share/applications ./Misc/Linux/com.orama_interactive.Pixelorama.desktop
    install -D -m 644 -T ./assets/graphics/icons/icon.png $out/share/icons/hicolor/256x256/apps/pixelorama.png
    install -d -m 755 $out/bin
    ln -s $out/libexec/pixelorama $out/bin/pixelorama

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "Free & open-source 2D sprite editor, made with the Godot Engine!";
    changelog = "https://github.com/Orama-Interactive/Pixelorama/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ felschr ];
    mainProgram = "pixelorama";
  };
})

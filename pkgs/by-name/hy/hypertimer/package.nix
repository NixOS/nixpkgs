{
  lib,
  stdenv,
  fetchFromGitea,
  autoPatchelfHook,
  godot_4,
  godot_4-export-templates,
  libGL,
  alsa-lib,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  vulkan-loader,
}:

let
  godot_version_folder = lib.replaceStrings [ "-" ] [ "." ] godot_4.version;
  version = "0.2.3";
in
stdenv.mkDerivation {
  name = "hypertimer";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "unfa";
    repo = "hypertimer";
    rev = version;
    hash = "sha256-OFSl58VLjft5BO2QMo0HRYozMI+SBHB+jbVvKQPPnIY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    godot_4
  ];

  runtimeDependencies = map lib.getLib [
    libGL
    alsa-lib
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXi
    libXrandr
    vulkan-loader
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/export_templates
    ln -s "${godot_4-export-templates}" "$HOME/.local/share/godot/export_templates/${godot_version_folder}"
    mkdir -p build
    godot4 --headless --export-release "Linux/X11" ./build/hypertimer

    runHook postBuild
  '';

  postBuild = ''
    printf "[Desktop Entry]
    Name=Hypertimer
    Exec=$out/bin/hypertimer
    Icon=hypertimer
    Terminal=false
    Type=Application" > hypertimer.desktop
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/bin ./build/hypertimer
    install -D -m 644 -t $out/share/applications ./hypertimer.desktop
    install -D -m 644 -T ./icon.png $out/share/icons/hicolor/128x128/apps/hypertimer.png

    runHook postInstall
  '';

  meta = {
    homepage = "https://codeberg.org/unfa/HyperTimer";
    description = "A visual countdown timer designed to require minimal effort to read and provide a reliable time reference";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mksafavi ];
    mainProgram = "hypertimer";
  };
}

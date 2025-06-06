{ lib
, stdenv
, alsa-lib
, autoPatchelfHook
, fetchFromGitHub
, godot3-headless
, godot3-export-templates
, libGLU
, libpulseaudio
, libX11
, libXcursor
, libXi
, libXinerama
, libXrandr
, libXrender
, nix-update-script
, udev
}:

let
  preset =
    if stdenv.isLinux then
      if stdenv.is64bit then "Linux/X11 64-bit"
      else "Linux/X11 32-bit"
    else if stdenv.isDarwin then "Mac OSX"
    else throw "unsupported platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "pixelorama";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "Orama-Interactive";
    repo = "Pixelorama";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-VEQjZ9kDqXz1hoT4PrsBtzoi1TYWyN+YcPMyf9qJMRE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    godot3-headless
  ];

  buildInputs = [
    libGLU
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXrender
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "${godot3-export-templates}/share/godot/templates" "$HOME/.local/share/godot/templates"
    mkdir -p build
    godot3-headless -v --export "${preset}" ./build/pixelorama
    godot3-headless -v --export-pack "${preset}" ./build/pixelorama.pck

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/pixelorama
    install -D -m 644 -t $out/libexec ./build/pixelorama.pck
    install -D -m 644 -t $out/share/applications ./Misc/Linux/com.orama_interactive.Pixelorama.desktop
    install -d -m 755 $out/bin
    ln -s $out/libexec/pixelorama $out/bin/pixelorama

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "Free & open-source 2D sprite editor, made with the Godot Engine!";
    changelog = "https://github.com/Orama-Interactive/Pixelorama/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ felschr ];
    mainProgram = "pixelorama";
  };
})

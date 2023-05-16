<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, godot-headless, godot-export-templates }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  preset =
    if stdenv.isLinux then
      if stdenv.is64bit then "Linux/X11 64-bit"
      else "Linux/X11 32-bit"
    else if stdenv.isDarwin then "Mac OSX"
    else throw "unsupported platform";
<<<<<<< HEAD
in stdenv.mkDerivation (finalAttrs: {
  pname = "pixelorama";
  version = "0.11.2";
=======
in stdenv.mkDerivation rec {
  pname = "pixelorama";
  version = "0.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Orama-Interactive";
    repo = "Pixelorama";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jSgSKxW7cxSoSwBytoaQtLwbkYm2udjmaZTHbN1jJwQ=";
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
=======
    rev = "v${version}";
    sha256 = "sha256-RFE7K8NMl0COzFEhUqWhhYd5MGBsCDJf0T5daPu/4DI=";
  };

  nativeBuildInputs = [
    godot-headless
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
<<<<<<< HEAD
    ln -s "${godot3-export-templates}/share/godot/templates" "$HOME/.local/share/godot/templates"
    mkdir -p build
    godot3-headless -v --export "${preset}" ./build/pixelorama
    godot3-headless -v --export-pack "${preset}" ./build/pixelorama.pck
=======
    ln -s "${godot-export-templates}/share/godot/templates" "$HOME/.local/share/godot/templates"
    mkdir -p build
    godot-headless -v --export "${preset}" ./build/pixelorama
    godot-headless -v --export-pack "${preset}" ./build/pixelorama.pck
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "A free & open-source 2D sprite editor, made with the Godot Engine!";
    changelog = "https://github.com/Orama-Interactive/Pixelorama/blob/${finalAttrs.src.rev}/CHANGELOG.md";
=======
  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "A free & open-source 2D sprite editor, made with the Godot Engine!";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ felschr ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

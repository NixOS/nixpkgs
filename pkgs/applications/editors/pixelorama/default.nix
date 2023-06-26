{ lib, stdenv, fetchFromGitHub, godot-headless, godot-export-templates, nix-update-script }:

let
  preset =
    if stdenv.isLinux then
      if stdenv.is64bit then "Linux/X11 64-bit"
      else "Linux/X11 32-bit"
    else if stdenv.isDarwin then "Mac OSX"
    else throw "unsupported platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "pixelorama";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "Orama-Interactive";
    repo = "Pixelorama";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-r4iQJBxXzIbQ7n19Ah6szuIfALmuKlHKcvKsxEzOttk=";
  };

  nativeBuildInputs = [
    godot-headless
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "${godot-export-templates}/share/godot/templates" "$HOME/.local/share/godot/templates"
    mkdir -p build
    godot-headless -v --export "${preset}" ./build/pixelorama
    godot-headless -v --export-pack "${preset}" ./build/pixelorama.pck

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://orama-interactive.itch.io/pixelorama";
    description = "A free & open-source 2D sprite editor, made with the Godot Engine!";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ felschr ];
  };
})

# copied from oh-my-git/package.nix by @jojosch (Johannes Schleifenbaum)
# added in nixos/nixpkgs#119642
{
  lib,
  autoPatchelfHook,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  stdenv,
  alsa-lib,
  godot3-export-templates,
  godot3-headless,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  libglvnd,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "a-keys-path";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "geegaz";
    repo = "A-Key-s-Path";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9INPB883/0fmtZgJpVpsA/7Q51DHOMWvkLF9hKE6gQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
  ];

  desktopItem = makeDesktopItem {
    name = "a-keys-path";
    exec = "a-keys-path";
    icon = "a-keys-path";
    desktopName = "a-keys-path";
    comment = "A game where you build your way with your keys";
    genericName = "A Key's Path";
    categories = [ "Game" ];
  };

  buildPhase = ''
    runHook preBuild

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/3.2.3.stable/linux_x11_64_release
    # with 3.2.3 being the version of godot.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    # export_presets.cfg copied here as it is .gitignored in source
    # created by godot editor (godot3 -e) Project > Export... and add Linux
    cp ${./export_presets.cfg} export_presets.cfg

    mkdir -p $out/share/a-keys-path
    godot3-headless --export "Linux" $out/share/a-keys-path/a-keys-path

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/a-keys-path/a-keys-path $out/bin

    # Patch binaries.
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf \
      --set-interpreter $interpreter \
      --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} \
      $out/share/a-keys-path/a-keys-path

    mkdir -p $out/share/pixmaps
    cp icon.png $out/share/pixmaps/a-keys-path.png

    install -Dm644 ${finalAttrs.desktopItem}/share/applications/a-keys-path.desktop \
      $out/share/applications/a-keys-path.desktop

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
  ];

  meta = {
    homepage = "https://geegaz.itch.io/out-of-controls";
    description = "Short puzzle-platformer game made with Godot, running on GLES 2.0";
    mainProgram = "a-keys-path";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-40
      cc0
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})

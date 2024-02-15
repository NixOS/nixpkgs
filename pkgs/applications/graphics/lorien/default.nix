{ lib
, stdenv
, fetchFromGitHub

, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem

, godot3-export-templates
, godot3-headless

, alsa-lib
, libGL
, libGLU
, libpulseaudio
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, zlib
, udev # for libudev
}:

let
  preset =
    if stdenv.isLinux then "Linux/X11"
    else if stdenv.isDarwin then "Mac OSX"
    else throw "unsupported platform";
in
stdenv.mkDerivation rec {
  pname = "lorien";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mbrlabs";
    repo = "Lorien";
    rev = "v${version}";
    sha256 = "sha256-mPv/3hyLGF3IUy6cKfGoABidIsyw4UfmhfhS4AD72K8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless
  ];

  buildInputs = [
    alsa-lib
    libGL
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    zlib
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lorien";
      exec = "lorien";
      icon = "lorien";
      desktopName = "Lorien";
      genericName = "Whiteboard";
      comment = meta.description;
      categories = [ "Graphics" "Office" ];
      keywords = [ "whiteboard" ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/{godot-version}.stable/linux_x11_64_release
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p $out/share/lorien

    godot3-headless --path lorien --export "${preset}" $out/share/lorien/lorien

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/lorien/lorien $out/bin

    # Patch binaries.
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf \
      --set-interpreter $interpreter \
      --set-rpath ${lib.makeLibraryPath buildInputs} \
      $out/share/lorien/lorien

    install -Dm644 images/lorien.png $out/share/pixmaps/lorien.png

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  meta = with lib; {
    homepage = "https://github.com/mbrlabs/Lorien";
    description = "An infinite canvas drawing/note-taking app";
    longDescription = ''
      An infinite canvas drawing/note-taking app that is focused on performance,
      small savefiles and simplicity
    '';
    license = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ hqurve ];
    mainProgram = "lorien";
  };
}

{
  copyDesktopItems,
  icoutils,
  imagemagick,
  lib,
  love,
  makeDesktopItem,
  makeWrapper,
  p7zip,
  requireFile,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moonring";
  version = "0.0.950";

  src = requireFile {
    name = "moonring-win.zip"; # Windows build is easiest to extract
    url = "https://dene.itch.io/moonring#download";
    # Use `nix --extra-experimental-features nix-command hash file --sri --type sha256` to get the correct hash
    hash = "sha256-DHTgl5wTv0yM416AzUNOsz0iTcRrcSKUg1lPoojQXLA=";
  };

  nativeBuildInputs = [
    p7zip
    copyDesktopItems
    icoutils
    imagemagick
    makeWrapper
  ];
  buildInputs = [ love ];

  dontUnpack = true;
  buildPhase = ''
    runHook preBuild

    # Unzip the file a user would download
    tmpdir=$(mktemp -d)
    7z x ${finalAttrs.src} -o$tmpdir -y

    # Unzip the executable contained within
    tmpdir2=$(mktemp -d)
    7z x $tmpdir/Moonring.exe -o$tmpdir2 -y

    # Reassemble
    patchedExe=$(mktemp -u).zip
    7z a $patchedExe $tmpdir2/*

    # Extract icon
    tmpdir3=$(mktemp -d)
    wrestool -x -t 14 $tmpdir/Moonring.exe > $tmpdir3/moonring.ico
    magick $tmpdir3/moonring.ico $tmpdir3/moonring.png

    runHook postBuild
  '';

  # The `cat` bit is a hack suggested by whitelje (https://github.com/ethangreen-dev/lovely-injector/pull/66#issuecomment-2319615509)
  # to make it so that love will pick up Moonring as the game name.
  installPhase = ''
    runHook preInstall
    install -Dm444 $tmpdir3/moonring-6.png -t $out/share/icons

    cat ${lib.getExe love} $patchedExe > $out/share/Moonring
    chmod +x $out/share/Moonring

    makeWrapper $out/share/Moonring $out/bin/moonring
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "moonring";
      desktopName = "Moonring";
      exec = "moonring";
      keywords = [ "Game" ];
      categories = [ "Game" ];
      icon = "moonring";
    })
  ];

  meta = {
    description = "Retro, Ultima-inspired RPG";
    longDescription = ''
      Moonring is a retro-inspired open-world, turn-based, tile RPG in the
      style of the old Ultima games, but created with modern design
      sensibilities, and a unique neon aesthetic.
    '';
    license = lib.licenses.unfree;
    homepage = "https://store.steampowered.com/app/2373630/Moonring/";
    maintainers = [ lib.maintainers.jonhermansen ];
    platforms = love.meta.platforms;
    mainProgram = "moonring";
  };
})

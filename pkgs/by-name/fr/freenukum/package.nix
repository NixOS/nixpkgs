{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  makeDesktopItem,
  installShellFiles,
  copyDesktopItems,
  dejavu_fonts,
  SDL2,
  SDL2_ttf,
  SDL2_image,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "freenukum";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "silwol";
    repo = "freenukum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tk9n2gPwyPin6JZ4RSO8d/+xVpEz4rF8C2eGKwrAXU0=";
  };

  cargoHash = "sha256-lQZ9Z/1tbL7BeLmGxJXNUvrXsOGtgzGXNt6WYGezxi0=";

  nativeBuildInputs = [
    installShellFiles
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = finalAttrs.pname;
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = "Clone of the original Duke Nukum 1 Jump'n Run game";
      categories = [
        "Game"
        "ArcadeGame"
        "ActionGame"
      ];
      genericName = finalAttrs.pname;
    })
  ];

  postPatch = ''
    substituteInPlace src/graphics.rs \
      --replace /usr $out
  '';

  postInstall = ''
    mkdir -p $out/share/fonts/truetype/dejavu
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf \
      $out/share/fonts/truetype/dejavu/DejaVuSans.ttf
    mkdir -p $out/share/doc/freenukum
    install -Dm644 README.md CHANGELOG.md $out/share/doc/freenukum/
    installManPage doc/freenukum.6
  '';

  meta = {
    description = "Clone of the original Duke Nukum 1 Jump'n Run game";
    homepage = "https://salsa.debian.org/silwol/freenukum";
    changelog = "https://salsa.debian.org/silwol/freenukum/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  ncurses,
  asciidoctor,
  installShellFiles,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "battleships";
  version = "2.15";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "bs";
    tag = finalAttrs.version;
    hash = "sha256-7HOqgiZ/KeY+ZKZVaM6Dl52S32NiVvWwwxByVQcJ49g=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ];

  buildFlags = [
    "bs"
    "bs.6"
  ];

  # Upstream bs.c has two declaration mismatches that newer GCC treats
  # as errors
  postPatch = ''
    substituteInPlace bs.c  \
      --replace-fail "static bool checkplace(int b, ship_t *ss, int vis);"  \
                     "static bool checkplace(int b, const ship_t *ss, int vis);"  \
      --replace-fail "static void do_options(int c, const char *op[]) {"  \
                     "static void do_options(int c, char *op[]) {"

    substituteInPlace bs.desktop  \
      --replace-fail "Exec=bs" "Exec=battleships"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bs $out/bin/battleships
    cp bs.6 battleships.6
    installManPage battleships.6
    install -Dm644 bs.desktop $out/share/applications/battleships.desktop
    install -Dm644 battleship.png  \
      $out/share/icons/hicolor/32x32/apps/battleship.png
    install -Dm644 bs.adoc $out/share/appdata/battleships.adoc

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The classic game of Battleships against the computer";
    homepage = "https://gitlab.com/esr/bs";
    changelog = "https://gitlab.com/esr/bs/-/tags/${finalAttrs.version}";
    mainProgram = "battleships";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})

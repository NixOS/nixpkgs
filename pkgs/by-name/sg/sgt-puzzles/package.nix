{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  gtk3,
  libX11,
  cmake,
  imagemagick,
  pkg-config,
  perl,
  wrapGAppsHook3,
  nixosTests,
  writeScript,
  halibut,
  isMobile ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sgt-puzzles";
  version = "20251120.28032bd";

  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${finalAttrs.version}.tar.gz";
    hash = "sha256-aD4EOuquUpjtmKVClzIKbO+6LD2T3vqgSDf7D/wPYrE=";
  };

  sgt-puzzles-menu = fetchurl {
    url = "https://raw.githubusercontent.com/gentoo/gentoo/720e614d0107e86fc1e520bac17726578186843d/games-puzzle/sgt-puzzles/files/sgt-puzzles.menu";
    hash = "sha256-dXbx6C5/uu0S1FxfOLJ8TjdoJ/IW9VjEsRfJ8VIHHCE=";
  };

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    imagemagick
    perl
    pkg-config
    wrapGAppsHook3
    halibut # For help pages
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString isMobile "-DSTYLUS_BASED";

  buildInputs = [
    gtk3
    libX11
  ];

  postInstall = ''
    for i in  $(basename -s $out/bin/*); do

      ln -s $out/bin/$i $out/bin/sgt-puzzle-$i
      install -Dm644 icons/$i-96d24.png -t $out/share/icons/hicolor/96x96/apps/

      # Generate/validate/install .desktop files.
      echo "[Desktop Entry]" > $i.desktop
      desktop-file-install --dir $out/share/applications \
        --set-key Type --set-value Application \
        --set-key Exec --set-value $i \
        --set-key Name --set-value $i \
        --set-key Comment --set-value "${finalAttrs.meta.description}" \
        --set-key Categories --set-value "Game;LogicGame;X-sgt-puzzles;" \
        --set-key Icon --set-value $out/share/icons/hicolor/96x96/apps/$i-96d24.png \
        $i.desktop
    done

    echo "[Desktop Entry]" > sgt-puzzles.directory
    desktop-file-install --dir $out/share/desktop-directories \
      --set-key Type --set-value Directory \
      --set-key Name --set-value Puzzles \
      --set-key Icon --set-value $out/share/icons/hicolor/48x48/apps/sgt-puzzles_map \
      sgt-puzzles.directory

    install -Dm644 ${finalAttrs.sgt-puzzles-menu} -t $out/etc/xdg/menus/applications-merged/
  '';

  passthru = {
    tests.sgt-puzzles = nixosTests.sgt-puzzles;
    updateScript = writeScript "update-sgt-puzzles" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      version="$(curl -sI 'https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz' | grep -Fi Location: | pcregrep -o1 'puzzles-([0-9a-f.]*).tar.gz')"
      update-source-version sgt-puzzles "$version"
    '';
  };

  meta = {
    description = "Simon Tatham's portable puzzle collection";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
      tomfitzhenry
    ];
    platforms = lib.platforms.linux;
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/";
  };
})

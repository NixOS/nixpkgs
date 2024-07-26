{ fetchFromGitHub
, glib
, gtk3
, lib
, libsoup_3
, networkmanager
, pkg-config
, rustPlatform
, webkitgtk_4_1
, wrapGAppsHook3
}:
rustPlatform.buildRustPackage rec {
  pname = "rmenu";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "imgurbot12";
    repo = "rmenu";
    hash = "sha256-khauloUGVuekR+Lran1DLnsxwY8sIf5PsEKY7sNy1K4=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libsoup_3
    networkmanager
    webkitgtk_4_1
  ];

  strictDeps = true;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gio-0.19.0" = "sha256-+PAQNJ9sTk8aKAhA/PLQWDCKDT/cQ+ukdbem7g1J+pU=";
      "nm-0.4.0" = "sha256-53ipJU10ZhIKIF7PCw5Eo/e/reUK0qpyTyE7uIrCD88=";
    };
  };

  postInstall = ''
    # copy themes and plugins
    mkdir $out/themes
    mkdir $out/plugins
    cp -vfr $src/themes/* $out/themes/.
    cp -vfr $src/other-plugins/* $out/plugins/.
    mv $out/bin/* $out/plugins # everything is a plugin by default

    # rmenu and rmenu-build are actual binaries
    mv $out/plugins/rmenu $out/bin/rmenu
    mv $out/plugins/rmenu-build $out/bin/rmenu-build

    # fix plugin names
    # desktop  network  pactl-audio.sh  powermenu.sh  run  window
    mv $out/plugins/run $out/plugins/rmenu-run
    mv $out/plugins/desktop $out/plugins/rmenu-desktop
    mv $out/plugins/network $out/plugins/rmenu-network
    mv $out/plugins/window $out/plugins/rmenu-window

    # fix config and theme
    mkdir -p $out/share/rmenu
    cp -vf $src/rmenu/public/config.yaml $out/share/rmenu/config.yaml
    substituteInPlace $out/share/rmenu/config.yaml --replace "~/.config/rmenu" "$out"
    ln -sf  $out/themes/dark.css $out/share/rmenu/style.css
  '';

  preFixup = ''
    # rmenu expects the config to be in XDG_CONFIG_DIRS
    # shell script plugins called from rmenu binary expect the rmenu-build binary to be on the PATH,
    # which needs wrapping in temporary environments like shells and flakes
    gappsWrapperArgs+=(
      --suffix XDG_CONFIG_DIRS : "$out/share"
      --suffix PATH : "$out/bin"
    )
  '';

  meta = {
    changelog = "https://github.com/imgurbot12/rmenu/releases/tag/v${version}";
    description = "Another customizable Application-Launcher written in Rust";
    homepage = "https://github.com/imgurbot12/rmenu";
    license = lib.licenses.mit;
    mainProgram = "rmenu";
    maintainers = with lib.maintainers; [ grimmauld ];
    platforms = lib.platforms.linux;
  };
}

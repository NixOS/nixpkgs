{
  cmake,
  fetchFromGitHub,
  glib,
  gtk3,
  lib,
  libsoup_3,
  networkmanager,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdotool,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "rmenu";
  version = "1.3.0";

  src = fetchFromGitHub {
    tag = "v${version}";
    owner = "imgurbot12";
    repo = "rmenu";
    hash = "sha256-cmuB7JfHQuDFo8YaenTDwpe+TxKFaoJM5YwrT7eAfPM=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libsoup_3
    networkmanager
    webkitgtk_4_1
    xdotool
  ];

  strictDeps = true;

  cargoHash = "sha256-FIlFy3/Hih40My5fTykYjvaQEmnB3ZC5vX3lfKdW9Gk=";

  postInstall = ''
    # copy themes and plugins
    mkdir -p $out/themes $out/plugins/css
    cp -vfr $src/themes/* $out/themes
    cp -vfr $src/plugins/misc/* $out/plugins
    mv $out/bin/* $out/plugins # everything is a plugin by default

    # rmenu and rmenu-build are actual binaries
    mv $out/plugins/rmenu $out/bin/rmenu
    mv $out/plugins/rmenu-build $out/bin/rmenu-build

    # fix plugin names
    # desktop  network  pactl-audio.sh  powermenu.sh  run  window  emoji  search
    for plugin in desktop emoji files network run search window ; do
      mv $out/plugins/$plugin $out/plugins/rmenu-$plugin
    done

    # fix config and theme
    mkdir -p $out/share/rmenu
    cp -vf $src/rmenu/public/config.yaml $out/share/rmenu/config.yaml
    cp -vf $src/plugins/emoji/css/* $out/plugins/css
    substituteInPlace $out/share/rmenu/config.yaml --replace-fail "~/.config/rmenu" "$out"
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

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

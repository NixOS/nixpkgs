{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  nix-update-script,
  sassc,
}:

stdenvNoCC.mkDerivation {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "9b8be4d6648ae9eaae3dd550105081f8c9054825";
    hash = "sha256-XHO6NoXJwwZ8gBzZV/hJnVq5BvkEKYWvqLBQT00dGdE=";
  };

  patches = [
    # remove when merged
    # https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/pull/34
    ./fix-install-script.patch
    # remove when merged
    # https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/pull/35
    ./gtk3-remove-border-spacing.patch
    # The GTK2 themes need an engine that is no longer packaged.
    # Replace with --no-gtk2 once merged:
    # https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/pull/36
    ./remove-gtk2.patch
  ];

  nativeBuildInputs = [
    gtk3
    sassc
  ];

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs themes/install.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/"{themes,icons}

    cp -a icons/* "$out/share/icons/"

    for theme in "$out/share/icons/"*; do
      gtk-update-icon-cache "$theme"
    done

    cd themes
    ./install.sh --name Everforest --theme all --dest "$out/share/themes"
    cd ..

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Everforest colour palette for GTK";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ poz ];
    platforms = lib.platforms.all;
  };
}

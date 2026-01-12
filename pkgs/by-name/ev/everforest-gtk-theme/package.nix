{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  gnome-themes-extra,
  gtk-engine-murrine,
  gtk3,
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
    # fixes install script, remove when merged
    (fetchpatch {
      url = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/pull/34.patch";
      hash = "sha256-NvAiw8Bqxj3bVh9Hb9lT7HwHJ2latRsbzz4IpAD0sK8=";
    })
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  nativeBuildInputs = [
    gtk3
    sassc
  ];

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

  meta = {
    description = "Everforest colour palette for GTK";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jn-sena ];
    platforms = lib.platforms.unix;
  };
}

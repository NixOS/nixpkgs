{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  python3,
  sassc,
  elementary-xfce-icon-theme,
  vanilla-dmz,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gradient-blue-theme";
  version = "48.6";

  src = fetchFromGitHub {
    owner = "kanehekili";
    repo = "Gradient-blue";
    tag = "V${finalAttrs.version}";
    hash = "sha256-xicdkunHqyBJ53f7kwqfwDahoJgLRnyod0KoR4vaFw8=";
  };

  nativeBuildInputs = [
    python3
    sassc
  ];

  buildInputs = [
    elementary-xfce-icon-theme
    vanilla-dmz
  ];

  buildPhase = ''
    runHook preBuild
    python3 packaging/build_all.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes

    for variant in build/*; do
      for tarball in $variant/*; do
        tar -C $out/share/themes -xzf $tarball
      done
    done

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Multi-coloured skeuomorphic GTK2/3/4 theme with support for XFCE, Cinnamon and GNOME";
    homepage = "https://www.gnome-look.org/p/1185760/";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mansalia ];
    platforms = lib.platforms.unix;
  };
})

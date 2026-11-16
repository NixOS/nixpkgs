{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  nix-update-script,
  sassc,
  border-radius ? null, # Suggested: 2 < value < 16
  tweaks ? [ ], # can be "solid" "compact" "black" "primary" "macos" "submenu" "nord|dracula"
  withWallpapers ? false,
}:

let
  pname = "orchis-theme";

  validTweaks = [
    "solid"
    "compact"
    "black"
    "primary"
    "macos"
    "submenu"
    "nord"
    "dracula"
  ];

  nordXorDracula =
    with builtins;
    lib.assertMsg (!(elem "nord" tweaks) || !(elem "dracula" tweaks)) ''
      ${pname}: dracula and nord cannot be mixed. Tweaks ${toString tweaks}
    '';
in

assert nordXorDracula;
lib.checkListOfEnum "${pname}: theme tweaks" validTweaks tweaks

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "2026-07-07";

    src = fetchFromGitHub {
      repo = "Orchis-theme";
      owner = "vinceliuice";
      tag = finalAttrs.version;
      hash = "sha256-oX6+tPe0nGsl+OzFZCpbKvE00Z/xvP+NoHY7QZ9YAo0=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      gtk3
      sassc
    ];

    # The GTK2 themes need an engine that is no longer packaged.
    # Replace with --no-gtk2 once merged:
    # https://github.com/vinceliuice/Orchis-theme/pull/603
    patches = [ ./remove-gtk2.patch ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      bash install.sh -d $out/share/themes -t all \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        ${lib.optionalString (border-radius != null) ("--round " + toString border-radius + "px")}
      ${lib.optionalString withWallpapers ''
        mkdir -p $out/share/backgrounds
        cp src/wallpaper/{1080p,2k,4k}.jpg $out/share/backgrounds
      ''}
      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Material Design theme for GNOME/GTK based desktop environments";
      homepage = "https://github.com/vinceliuice/Orchis-theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.ncfavier ];
    };
  })

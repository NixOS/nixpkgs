{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  jdupes,
  sassc,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  sizeVariants ? [ ], # default: standard
  tweaks ? [ ],
  wallpapers ? false,
  withGrub ? false,
  grubScreens ? [ ], # default: 1080p
}:

let
  pname = "graphite-gtk-theme";

in
lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "blue"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "standard" "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: size variants"
  [ "standard" "compact" ]
  sizeVariants
  lib.checkListOfEnum
  "${pname}: tweaks"
  [
    "nord"
    "black"
    "darker"
    "rimless"
    "normal"
    "float"
    "colorful"
  ]
  tweaks
  lib.checkListOfEnum
  "${pname}: grub screens"
  [ "1080p" "2k" "4k" ]
  grubScreens

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "2026-08-23";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "graphite-gtk-theme";
      tag = finalAttrs.version;
      hash = "sha256-hovFi3UQb/DFVtQv43TjSoTF2IMNrkjtozj29dPJY64=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
    # Replace with --no-gtk2 once merged:
    # https://github.com/vinceliuice/Graphite-gtk-theme/pull/228
    patches = [ ./remove-gtk2.patch ];

    postPatch = ''
      patchShebangs .

      # install_app puts a GTK4 theme-switcher GUI in $HOME; this package ships themes.
      substituteInPlace install.sh \
        --replace-fail "install_theme && install_app" "install_theme"

      substituteInPlace wallpaper/install-wallpapers.sh \
       --replace-fail /usr/share $out/share \
       --replace-fail '[[ "$UID" -eq "$ROOT_UID" ]]' true
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      name= ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--size " + toString sizeVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        --dest $out/share/themes

      ${lib.optionalString wallpapers "sh -x wallpaper/install-wallpapers.sh"}

      ${lib.optionalString withGrub ''
        (
        cd other/grub2

        patchShebangs install.sh

        ./install.sh --justcopy --dest $out/share/grub/themes \
          ${lib.optionalString (builtins.elem "nord" tweaks) "--theme nord"} \
          ${lib.optionalString (grubScreens != [ ]) "--screen " + toString grubScreens}
        )
      ''}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Flat Gtk+ theme based on Elegant Design";
      homepage = "https://github.com/vinceliuice/Graphite-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ FlorianFranzen ];
    };
  })

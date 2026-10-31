{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
  nix-update-script,
  sassc,
  themeVariants ? [ ], # default: teal
  colorVariants ? [ ], # default: all
  sizeVariants ? [ ], # default: standard
  tweaks ? [ ],
}:

let
  pname = "jasper-gtk-theme";

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
    "blue"
    "grey"
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
    "dracula"
    "black"
    "macos"
  ]
  tweaks

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-04-02";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Jasper-gtk-theme";
      rev = "71cb99a6618d839b1058cb8e6660a3b2f63aca70";
      hash = "sha256-ZWPUyVszDPUdzttAJuIA9caDpP4SQ7mIbCoczxwvsus=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
    # Replace with --no-gtk2 once merged:
    # https://github.com/vinceliuice/Jasper-gtk-theme/pull/40
    patches = [ ./remove-gtk2.patch ];

    postPatch = ''
      patchShebangs .
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

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    meta = {
      description = "Modern and clean Gtk theme";
      homepage = "https://github.com/vinceliuice/Jasper-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ FlorianFranzen ];
    };
  }

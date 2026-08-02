{
  lib,
  stdenv,
  fetchFromGitHub,
  jdupes,
  nix-update-script,
  sassc,
  accent ? [ "default" ],
  shade ? "dark",
  size ? "standard",
  tweaks ? [ ],
  radius ? null,
  shell_radius ? radius,
  shell_float ? false,
  shell_opacity ? null,
  shell_no-border ? false,
}:
let
  validAccents = [
    "default"
    "blue"
    "flamingo"
    "green"
    "grey"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
    "all"
  ];
  validShades = [
    "light"
    "dark"
  ];
  validSizes = [
    "standard"
    "compact"
  ];
  validTweaks = [
    "frappe"
    "macchiato"
    "black"
    "border"
    "macos"
    "files-legacy"
  ];

  single = x: lib.optional (x != null) x;
  pname = "Catppuccin-GTK";
in
lib.checkListOfEnum "${pname} Valid theme accent(s)" validAccents accent lib.checkListOfEnum
  "${pname} Valid shades"
  validShades
  (single shade)
  lib.checkListOfEnum
  "${pname} Valid sizes"
  validSizes
  (single size)
  lib.checkListOfEnum
  "${pname} Valid tweaks"
  validTweaks
  tweaks

  stdenv.mkDerivation
  (finalAttrs: {
    pname = "magnetic-${lib.toLower pname}";
    version = "1.0.1";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Catppuccin-GTK-Theme";
      tag = "v${finalAttrs.version}";
      hash = "sha256-wS5Pt/Ao4iFY9Nc5ceDUHTVB5pZLyIoaPUSavja3pHw=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done

      rm -r themes/src/main/gtk-2.0
      sed -i '/gtk-2/Is/^.*$/:/' themes/lib/installers/gtk.sh themes/lib/gtkrc.sh

      substituteInPlace themes/lib/utils.sh \
        --replace-fail 'LOG_FILE="''${HOME}/.cache/catppuccin-install.log"' 'LOG_FILE=/dev/null'
    '';

    dontBuild = true;

    passthru.updateScript = nix-update-script { };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      BATCH_MODE=true ./themes/install.sh \
        --name ${pname} \
        ${toString (map (x: "--theme " + x) accent)} \
        ${lib.optionalString (shade != null) ("--color " + shade)} \
        ${lib.optionalString (size != null) ("--size " + size)} \
        ${toString (map (x: "--tweaks " + x) tweaks)} \
        ${lib.optionalString (radius != null) "--tweaks radius ${toString radius}"} \
        ${lib.optionalString (shell_radius != null) "--shell radius ${toString shell_radius}"} \
        ${lib.optionalString (shell_opacity != null) "--shell opacity ${toString shell_opacity}"} \
        ${lib.optionalString shell_float "--shell float"} \
        ${lib.optionalString shell_no-border "--shell no-border"} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "GTK Theme with Catppuccin colour scheme";
      homepage = "https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        icy-thought
        Username404-59
      ];
      platforms = lib.platforms.all;
    };
  })

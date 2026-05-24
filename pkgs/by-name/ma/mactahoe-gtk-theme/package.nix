{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  dialog,
  glib,
  gnome-themes-extra,
  jdupes,
  libxml2,
  sassc,
  util-linux,

  # Window control button variants
  altVariants ? [ ], # default: normal
  # Color (light/dark) variants
  colorVariants ? [ ], # default: all
  # Window transparency variants
  opacityVariants ? [ ], # default: all
  # Accent color variants
  themeVariants ? [ ], # default: default (Tahoe green)
  # GTK color scheme variants
  schemeVariants ? [ ], # default: standard

  # Toggles passed to install.sh
  withBlur ? false, # --blur: more transparent style (pairs with blur-my-shell)
  withLibadwaita ? false, # --libadwaita: also overrides gtk-4.0 for libadwaita apps
  fixedAccent ? false, # --fixed: use a fixed accent instead of an adaptive one
  highDefinition ? false, # --highdefinition: HD assets
  roundedMaxWindow ? false, # --round: rounded corners on maximized windows
  darkerColor ? false, # --darker: even darker dark variant

  # GNOME Shell options (any of these implies installing the shell theme)
  iconVariant ? null, # -i: activities icon style
  panelOpacity ? null, # -p: top panel opacity (% string)
  panelHeight ? null, # -h: top panel height
  smallerFont ? false, # -sf: 10pt base font
  noShadow ? false, # -ns: remove quick menu shadow
  normalAppsButton ? false, # normal apps button instead of the Apple icon

  # Wallpapers (installs MacTahoe-day/night to $out/share/backgrounds)
  withWallpapers ? true,
}:

let
  pname = "mactahoe-gtk-theme";
  single = x: lib.optional (x != null) x;
  shellNeeded =
    iconVariant != null
    || panelOpacity != null
    || panelHeight != null
    || smallerFont
    || noShadow
    || normalAppsButton;
in
lib.checkListOfEnum "${pname}: window control buttons variants" [ "normal" "alt" "all" ] altVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "normal" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: accent color variants"
  [
    "default"
    "blue"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: colorscheme style variants"
  [ "standard" "nord" ]
  schemeVariants
  lib.checkListOfEnum
  "${pname}: activities icon variants"
  [
    "apple"
    "simple"
    "gnome"
    "ubuntu"
    "tux"
    "arch"
    "manjaro"
    "fedora"
    "debian"
    "void"
    "opensuse"
    "popos"
    "mxlinux"
    "zorin"
    "budgie"
    "gentoo"
  ]
  (single iconVariant)
  lib.checkListOfEnum
  "${pname}: panel opacity"
  [ "default" "30" "45" "60" "75" ]
  (single panelOpacity)
  lib.checkListOfEnum
  "${pname}: panel height"
  [ "default" "smaller" "bigger" ]
  (single panelHeight)

  stdenv.mkDerivation
  rec {
    inherit pname;
    version = "2026-05-24";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-gtk-theme";
      rev = version;
      hash = "sha256-q+r8QO974UVPsgfrNpBI4wfvE1OzvhvYCVC0byPwAzI=";
    };

    nativeBuildInputs = [
      dialog
      glib
      jdupes
      libxml2
      sassc
      util-linux
    ];

    buildInputs = [
      gnome-themes-extra # adwaita engine for Gtk2
    ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done

      # Do not provide `sudo`, as it is not needed in our use case of the install script
      substituteInPlace libs/lib-core.sh --replace-fail '$(which sudo)' false

      # Provides a dummy home directory
      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'

      # When --shell is requested, the installer probes `gnome-shell --version`
      # to pick the matching SCSS partial. gnome-shell isn't available inside
      # the build sandbox, so we hard-pin the detected version and short-circuit
      # the probe. The pinned value tracks the SCSS partials shipped by the
      # current upstream release; bump it together with the upstream tag.
      # TODO: derive this from `pkgs.gnome-shell.version` instead of pinning.
      substituteInPlace libs/lib-core.sh --replace-fail \
        'if command -v gnome-shell &> /dev/null; then' \
        'SHELL_VERSION="48"; GNOME_VERSION="48-0"; if false; then'
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./install.sh \
        ${toString (map (x: "--alt " + x) altVariants)} \
        ${toString (map (x: "--color " + x) colorVariants)} \
        ${toString (map (x: "--opacity " + x) opacityVariants)} \
        ${toString (map (x: "--theme " + x) themeVariants)} \
        ${toString (map (x: "--scheme " + x) schemeVariants)} \
        ${lib.optionalString withBlur "--blur"} \
        ${lib.optionalString withLibadwaita "--libadwaita"} \
        ${lib.optionalString fixedAccent "--fixed"} \
        ${lib.optionalString highDefinition "--highdefinition"} \
        ${lib.optionalString roundedMaxWindow "--round"} \
        ${lib.optionalString darkerColor "--darker"} \
        ${lib.optionalString shellNeeded "--shell"} \
        ${lib.optionalString (iconVariant != null) ("-i " + iconVariant)} \
        ${lib.optionalString (panelOpacity != null) ("-p " + panelOpacity)} \
        ${lib.optionalString (panelHeight != null) ("-h " + panelHeight)} \
        ${lib.optionalString smallerFont "-sf"} \
        ${lib.optionalString noShadow "-ns"} \
        ${lib.optionalString normalAppsButton "normal"} \
        --dest $out/share/themes

      ${lib.optionalString withWallpapers ''
        mkdir -p $out/share/backgrounds/mactahoe
        cp -r wallpaper/MacTahoe-day.jpeg wallpaper/MacTahoe-night.jpeg wallpaper/MacTahoe.xml \
          $out/share/backgrounds/mactahoe/
      ''}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "MacOS Tahoe like Gtk theme based on WhiteSur";
      homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ eduardofortesr ];
    };
  }

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  boldPanelIcons ? false,
  themeVariants ? [ ],
}:

let
  pname = "mactahoe-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "blue"
    "purple"
    "green"
    "red"
    "orange"
    "yellow"
    "grey"
    "nord"
    "all"
  ]
  themeVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2026-07-07";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-icon-theme";
      tag = "${version}";
      hash = "sha256-CXZn4r1B+eB2Uv00vutFGQjOKJIia/I5RkPOBAAJKYA=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    buildInputs = [ hicolor-icon-theme ];

    # These fixup steps are slow and unnecessary
    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh

      # Fix upstream symlink, whose relative target is invalid after installation.
      rm links/status/symbolic/globe-symbolic.svg
      ln -s ../../places/symbolic/network-workgroup-symbolic.svg \
        links/status/symbolic/globe-symbolic.svg
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh --dest $out/share/icons \
        --name MacTahoe \
        --theme ${toString themeVariants} \
        ${lib.optionalString boldPanelIcons "--bold"}

      jdupes --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "MacOS Tahoe style icon theme for Linux desktops";
      homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ hesprs ];
    };
  }

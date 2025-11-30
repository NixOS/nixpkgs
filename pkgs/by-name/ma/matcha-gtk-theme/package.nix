{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gdk-pixbuf,
  gtk-engine-murrine,
  jdupes,
  librsvg,
  gitUpdater,
  colorVariants ? [ ], # default: all
  themeVariants ? [ ], # default: blue
}:

let
  pname = "matcha-gtk-theme";

in
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
  lib.checkListOfEnum
  "${pname}: theme variants"
  [ "aliz" "azul" "sea" "pueril" "all" ]
  themeVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025-04-11";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "matcha-gtk-theme";
      rev = version;
      sha256 = "sha256-vPAGEa3anWAynEg2AYme4qpHJdLDKk2CmL5iQ1mBYgM=";
    };

    nativeBuildInputs = [
      jdupes
    ];

    buildInputs = [
      gdk-pixbuf
      librsvg
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      name= ./install.sh \
        ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
        --dest $out/share/themes

      mkdir -p $out/share/doc/matcha-gtk-theme
      cp -a src/extra/firefox $out/share/doc/matcha-gtk-theme

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = with lib; {
      description = "Stylish flat Design theme for GTK based desktop environments";
      homepage = "https://vinceliuice.github.io/theme-matcha";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = [ maintainers.romildo ];
    };
  }

{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  jdupes,
  sassc,
  which,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  tweaks ? [ ],
}:

let
  pname = "qogir-theme";

in
lib.checkListOfEnum "${pname}: theme variants" [ "default" "manjaro" "ubuntu" "all" ] themeVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "standard" "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: tweaks"
  [ "image" "square" "round" ]
  tweaks

  stdenv.mkDerivation
  rec {
    inherit pname;
    version = "2025-08-17";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "qogir-theme";
      rev = version;
      hash = "sha256-LS1BE2jR08/JW2+rixYhTmctAfK2yZVWIE4QnAX9PDQ=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
      which
    ];

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        --dest $out/share/themes

      mkdir -p $out/share/doc/qogir-theme
      cp -a src/firefox $out/share/doc/qogir-theme

      rm $out/share/themes/*/{AUTHORS,COPYING}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "Flat Design theme for GTK based desktop environments";
      homepage = "https://github.com/vinceliuice/Qogir-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = [ lib.maintainers.romildo ];
    };
  }

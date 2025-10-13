{
  lib,
  stdenv,
  fetchurl,
  racket-minimal,

  cairo,
  fontconfig,
  glib,
  glibcLocales,
  gtk3,
  libGL,
  libiodbc,
  libjpeg,
  libpng,
  makeFontsConf,
  pango,
  unixODBC,
  wrapGAppsHook3,

  disableDocs ? false,

  callPackage,
}:

let
  minimal = racket-minimal.override { inherit disableDocs; };

  manifest = lib.importJSON ./manifest.json;
  inherit (stdenv.hostPlatform) isDarwin;
in

minimal.overrideAttrs (
  finalAttrs: prevAttrs: {
    src = fetchurl {
      url = "https://mirror.racket-lang.org/installers/${manifest.version}/${manifest.full.filename}";
      inherit (manifest.full) sha256;
    };

    buildInputs = prevAttrs.buildInputs ++ [
      (if isDarwin then libiodbc else unixODBC)
      cairo
      fontconfig.lib
      glib
      gtk3
      libGL
      libjpeg
      libpng
      pango
    ];

    nativeBuildInputs = [
      wrapGAppsHook3
    ];

    patches = prevAttrs.patches or [ ] ++ [
      /*
        Hardcode variant detection because nixpkgs wraps the Racket binary making it
        fail to detect its variant at runtime.
        https://github.com/NixOS/nixpkgs/issues/114993#issuecomment-812951247
      */
      ./patches/force-cs-variant.patch
    ];

    preBuild =
      let
        libPathsVar = if isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      in
      /*
        Makes FFIs available for setting up `main-distribution` and its
        dependencies, which is integrated into the build process of Racket
      */
      ''
        for lib_path in $( \
            echo "$NIX_LDFLAGS" \
              | tr ' ' '\n' \
              | grep '^-L' \
              | sed 's/^-L//' \
              | awk '!seen[$0]++' \
        ); do
            addToSearchPath ${libPathsVar} $lib_path
        done
      ''
      # Fixes Fontconfig errors
      + ''
        export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
        export XDG_CACHE_HOME=$(mktemp -d)
      '';

    preFixup = lib.optionalString (!isDarwin) ''
      gappsWrapperArgs+=("--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive")
    '';

    passthru =
      let
        notUpdated = x: !builtins.isAttrs x || lib.isDerivation x;
        stopPred =
          _: lhs: rhs:
          notUpdated lhs || notUpdated rhs;
      in
      lib.recursiveUpdateUntil stopPred prevAttrs.passthru {
        tests = builtins.mapAttrs (name: path: callPackage path { racket = finalAttrs.finalPackage; }) {
          ## `main-distribution` ##
          draw-crossing = ./tests/draw-crossing.nix;
        };
      };

    meta = prevAttrs.meta // {
      description = "Programmable programming language";
      longDescription = ''
        Racket is a full-spectrum programming language. It goes beyond
        Lisp and Scheme with dialects that support objects, types,
        laziness, and more. Racket enables programmers to link
        components written in different dialects, and it empowers
        programmers to create new, project-specific dialects. Racket's
        libraries support applications from web servers and databases to
        GUIs and charts.
      '';
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
    };
  }
)

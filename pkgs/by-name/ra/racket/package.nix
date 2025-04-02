{
  lib,
  stdenv,
  fetchurl,

  isMinimal,

  libiconvReal,
  libz,
  lz4,
  ncurses,
  openssl,
  sqlite,

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
  writers,
}:

let
  manifest = lib.importJSON ./manifest.json;

  inherit (stdenv.hostPlatform) isDarwin;

  kind = if isMinimal then "minimal" else "full";

  makeLibPaths = lib.concatMapStringsSep " " (
    lib.flip lib.pipe [
      lib.getLib
      (x: ''"${x}/lib"'')
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "racket";
  inherit (manifest) version;

  src = fetchurl {
    url = "https://mirror.racket-lang.org/installers/${manifest.version}/${manifest.${kind}.filename}";
    inherit (manifest.${kind}) sha256;
  };

  nativeBuildInputs = lib.optionals (!isMinimal) [
    wrapGAppsHook3
  ];

  buildInputs =
    [
      libiconvReal
      libz
      lz4
      ncurses
      openssl
      sqlite.out
    ]
    ++ lib.optionals (!isMinimal) [
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

  patches =
    lib.optionals isDarwin [
      /*
        The entry point binary $out/bin/racket is codesigned at least once. The
        following error is triggered as a result.
        (error 'add-ad-hoc-signature "file already has a signature")
        We always remove the existing signature then call add-ad-hoc-signature to
        circumvent this error.
      */
      ./patches/force-remove-codesign-then-add.patch
    ]
    ++ lib.optionals (!isMinimal) [
      /*
        Hardcode variant detection because nixpkgs wraps the Racket binary making it
        fail to detect its variant at runtime.
        https://github.com/NixOS/nixpkgs/issues/114993#issuecomment-812951247
      */
      ./patches/force-cs-variant.patch
    ];

  preConfigure =
    /*
      The configure script forces using `libtool -o` as AR on Darwin. But, the
      `-o` option is only available from Apple libtool. GNU ar works here.
    */
    lib.optionalString isDarwin ''
      substituteInPlace src/ChezScheme/zlib/configure \
          --replace-fail 'ARFLAGS="-o"' 'AR=ar; ARFLAGS="rc"'
    ''
    + ''
      mkdir src/build
      cd src/build
    '';

  configureScript = "../configure";

  configureFlags =
    [
      # > docs failure: ftype-ref: ftype mismatch for #<ftype-pointer>
      # "--enable-check"
      "--enable-csonly"
      "--enable-liblz4"
      "--enable-libz"
    ]
    ++ lib.optional disableDocs "--disable-docs"
    ++ lib.optionals (!(finalAttrs.dontDisableStatic or false)) [
      # instead of `--disable-static` that `stdenv` assumes
      "--disable-libs"
      # "not currently supported" in `configure --help-cs` but still emphasized in README
      "--enable-shared"
    ]
    ++ lib.optionals isDarwin [
      "--disable-strip"
      # "use Unix style (e.g., use Gtk) for Mac OS", which eliminates many problems
      "--enable-xonx"
    ];

  # The upstream script builds static libraries by default.
  dontAddStaticConfigureFlags = true;

  preBuild = lib.optionals (!isMinimal) (
    let
      libPaths = makeLibPaths finalAttrs.buildInputs;
      libPathsVar = if isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    /*
      Makes FFIs available for setting up `main-distribution` and its
      dependencies, which is integrated into the build process of Racket
    */
    ''
      for lib_path in ${libPaths}; do
          addToSearchPath ${libPathsVar} $lib_path
      done
    ''
    # Fixes Fontconfig errors
    + ''
      export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
      export XDG_CACHE_HOME=$(mktemp -d)
    ''
  );

  dontStrip = isDarwin;

  preFixup = lib.optionalString (!isMinimal && !isDarwin) ''
    gappsWrapperArgs+=("--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive")
  '';

  postFixup =
    let
      configureInstallation = builtins.path {
        name = "configure-installation.rkt";
        path = ./configure-installation.rkt;
      };
    in
    ''
      $out/bin/racket -U -u ${configureInstallation}
    '';

  passthru = {
    # Functionalities #
    updateScript = {
      command = ./update.py;
      attrPath = "racket";
      supportedFeatures = [ "commit" ];
    };
    writeScript =
      nameOrPath:
      {
        libraries ? [ ],
        ...
      }@config:
      assert lib.assertMsg (libraries == [ ]) "library integration for Racket has not been implemented";
      writers.makeScriptWriter (
        builtins.removeAttrs config [ "libraries" ]
        // {
          interpreter = "${lib.getExe finalAttrs.finalPackage}";
        }
      ) nameOrPath;
    writeScriptBin = name: finalAttrs.passthru.writeScript "/bin/${name}";

    # Tests #
    tests = builtins.mapAttrs (name: path: callPackage path { racket = finalAttrs.finalPackage; }) (
      {
        ## Basic ##
        write-greeting = ./tests/write-greeting.nix;
        get-version-and-variant = ./tests/get-version-and-variant.nix;
        load-openssl = ./tests/load-openssl.nix;

        ## Nixpkgs supports ##
        nix-write-script = ./tests/nix-write-script.nix;
      }
      // lib.optionalAttrs (!isMinimal) {
        draw-crossing = ./tests/draw-crossing.nix;
      }
    );
  };

  meta = {
    description =
      "Programmable programming language" + lib.optionalString isMinimal " (minimal distribution)";
    longDescription =
      ''
        Racket is a full-spectrum programming language. It goes beyond
        Lisp and Scheme with dialects that support objects, types,
        laziness, and more. Racket enables programmers to link
        components written in different dialects, and it empowers
        programmers to create new, project-specific dialects. Racket's
        libraries support applications from web servers and databases to
        GUIs and charts.
      ''
      + lib.optionalString isMinimal ''

        This minimal distribution includes just enough of Racket that you can
        use `raco pkg` to install more.
      '';
    homepage = "https://racket-lang.org/";
    changelog = "https://github.com/racket/racket/releases/tag/v${finalAttrs.version}";
    /*
      > Racket is distributed under the MIT license and the Apache version 2.0
      > license, at your option.

      > The Racket runtime system embeds Chez Scheme, which is distributed
      > under the Apache version 2.0 license.
    */
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "racket";
    platforms = if isMinimal then lib.platforms.all else lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})

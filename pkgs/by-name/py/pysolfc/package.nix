{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  desktop-file-utils,
  wrapGAppsHook3,
  freecell-solver,
  black-hole-solver,
  gitUpdater,
  _experimental-update-script-combinators,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pysolfc";
  version = "3.4.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "shlomif";
    repo = "PySolFC";
    tag = "pysolfc-${finalAttrs.version}";
    hash = "sha256-Ky5lyr2dxP/gai/DPZXAtoJSYp0I2TM/rWUNFG1yNyU=";
  };

  format = "setuptools";

  nativeBuildInputs = [
    desktop-file-utils
    wrapGAppsHook3
  ];

  propagatedBuildInputs = with python3Packages; [
    tkinter
    six
    random2
    configobj
    pysol-cards
    attrs
    pycotap
    pygame-ce
    freecell-solver
    black-hole-solver
    pillow
  ];

  patches = [ ./pysolfc-datadir.patch ];

  # wrapGAppsHook wraps every executable under $out/bin, including the hidden
  # .pysolfc-wrapped script left by wrapPythonPrograms. Which produces a broken
  # Mach-O wrapper chain on Darwin.
  dontWrapGApps = stdenv.hostPlatform.isDarwin;

  postPatch = ''
    mv pysol.py pysol
    substituteInPlace setup.py data/pysol.desktop \
      --replace-fail "pysol.py" "pysol"
  '';

  # html/ is generated at release time (see upstream Makefile and macos-package.yml).
  preBuild = ''
    export PYTHONPATH="$PWD''${PYTHONPATH:+:}$PYTHONPATH"
    (cd html-src && ${python3Packages.python}/bin/python3 ./gen-html.py)

    cp -r html-src/images html-src/html
    rm -rf data/html
    mv html-src/html data
  '';

  postInstall = ''
    mkdir -p "$out/share/PySolFC/cardsets"
    cp -r ${finalAttrs.passthru.cardsets}/* "$out/share/PySolFC/cardsets/"
    cp -r ${finalAttrs.passthru.music}/data/music "$out/share/PySolFC/"

    install -Dm644 "$src/data/pysol.desktop" "$out/share/applications/pysolfc.desktop"
    substituteInPlace "$out/share/applications/pysolfc.desktop" \
      --replace-fail "Exec=pysol" "Exec=pysolfc"

    for size in 16 32 48 128 512; do
      install -Dm644 "$out/share/PySolFC/images/icons/''${size}x''${size}/pysol.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/pysolfc.png"
    done

    mv "$out/bin/pysol" "$out/bin/pysolfc"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app="$out/Applications/PySolFC.app"
    launcher="$out/bin/pysolfc"

    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
    install -Dm644 ${./Info.plist} "$app/Contents/Info.plist"
    substituteInPlace "$app/Contents/Info.plist" \
      --replace-fail '@VERSION@' "${finalAttrs.version}"

    cp "$src/data/PySol.icns" "$app/Contents/Resources/PySol.icns"

    # One gapps wrap on the setuptools launcher only (not .pysolfc-wrapped).
    wrapGApp "$launcher"
    install -Dm755 "$launcher" "$app/Contents/MacOS/pysolfc"
    ln -sfn "$app/Contents/MacOS/pysolfc" "$out/bin/pysolfc"
  '';

  # No tests in archive
  doCheck = false;

  passthru = {
    cardsets = stdenv.mkDerivation (cardsetsAttrs: {
      pname = "pysol-cardsets";
      version = "3.1";

      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "PySolFC-CardSets";
        tag = cardsetsAttrs.version;
        hash = "sha256-agbfeM19BCdbk73KZpvoRR0fCOSR7cpqlt7T1/MlM9g=";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out"
        runHook postInstall
      '';
    });

    music = stdenv.mkDerivation (musicAttrs: {
      pname = "pysol-music";
      version = "4.50";

      src = fetchFromGitHub {
        owner = "shlomif";
        repo = "pysol-music";
        tag = musicAttrs.version;
        hash = "sha256-sOl5U98aIorrQHJRy34s0HHaSW8hMUE7q84FMQAj5Yg=";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out"
        runHook postInstall
      '';
    });

    updateScript = _experimental-update-script-combinators.sequence (
      map (updater: updater.command) [
        (gitUpdater {
          url = "https://github.com/shlomif/PySolFC.git";
          rev-prefix = "pysolfc-";
        })
        (gitUpdater {
          url = "https://github.com/shlomif/PySolFC-CardSets.git";
          attrPath = "pysolfc.cardsets";
        })
        (gitUpdater {
          url = "https://github.com/shlomif/pysol-music.git";
          attrPath = "pysolfc.music";
        })
      ]
    );
  };

  meta = {
    description = "Collection of more than 1000 solitaire card games";
    mainProgram = "pysolfc";
    homepage = "https://pysolfc.sourceforge.io";
    changelog = "https://github.com/shlomif/PySolFC/releases/tag/pysolfc-${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})

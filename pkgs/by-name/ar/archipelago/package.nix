{
  lib,
  fetchFromGitHub,
  python311Packages,
  xsel,
  xclip,
  mtdev,
  nix-update-script,
  sni,
  enemizer,
  copyDesktopItems,
  makeDesktopItem,
  extraPackages ? [ ],
}:
let
  # Once next release is out, it should require the current version, so this can be removed
  zilliandomizer_0_7_1 = python311Packages.zilliandomizer.overridePythonAttrs (old: rec {
    version = "0.7.1";
    src = (
      old.src.override {
        rev = "v${version}";
        hash = "sha256-33WAScKQ9PMEmAy0/+mGKyh++wFLX36sbMCCszBOGC4=";
      }
    );
  });
in
python311Packages.buildPythonApplication rec {
  pname = "archipelago";
  version = "0.5.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ArchipelagoMW";
    repo = "Archipelago";
    rev = version;
    hash = "sha256-I6UHojEpC2/9bYK1khN1r+KsBTmU6zdsW8tpCYtB51I=";
  };

  patches = [
    # Fix references to paths inside the package
    ./fix-paths.patch
    # Stub out the ModuleUpdate module
    # So it doesn't try to update things at runtime.
    ./stub-moduleupdate.patch
  ];

  postPatch = ''
    # This is in a variable assignment, so `pythonRelaxDeps` doesn't work
    substituteInPlace setup.py \
      --replace-fail "cx-Freeze==7.0.0" "cx-Freeze"
    # tested `pythonRelaxDeps`, it doesn't work on this
    substituteInPlace requirements.txt \
      --replace-fail "certifi>=2024.6.2" "certifi"
    substituteInPlace worlds/_sc2common/requirements.txt \
      --replace-fail "protobuf==3.20.3" "protobuf"
    substituteInPlace Utils.py \
      --replace-fail '@ARCHI_LOCAL_PATH@' "$out/lib/python/archipelago/"
  '';

  build-system = with python311Packages; [
    setuptools
    copyDesktopItems
  ];

  dependencies =
    with python311Packages;
    [
      aiohttp
      astunparse
      bokeh
      bsdiff4
      certifi
      colorama
      cymem
      cython
      docutils
      factorio-rcon-py
      flask
      flask-compress
      flask-limiter
      flask-caching
      jellyfish
      jinja2
      kivy
      loguru
      markupsafe
      maseya-z3pr
      mpyq
      nest-asyncio
      orjson
      platformdirs
      pillow
      pony
      portpicker
      protobuf
      pyevermizer
      pymem
      pyyaml
      requests
      s2clientprotocol
      schema
      setuptools
      six
      tkinter
      typing-extensions
      waitress
      websockets
      werkzeug
      xxtea
      zilliandomizer_0_7_1
    ]
    ++ [
      # Non-python dependencies
      xsel
      xclip
      mtdev
      sni
    ]
    ++ extraPackages;

  makeWrapperArgs = [
    "--prefix PYTHONPATH : $program_PYTHONPATH"
    "--prefix PYTHONPATH : $out/lib/python/archipelago/"
    "--chdir $out/lib/python/archipelago"
  ] ++ lib.optional (extraPackages != [ ]) "--prefix-each PATH : $extraPackages";

  installPhase = ''
    runHook preInstall

    # We have to make the players folder, else it errors.
    # This stays empty, though.
    mkdir -p $out/lib/python/archipelago/Players
    mkdir -p $out/bin/Players

    mv {*.py,data,typings,worlds,requirements.txt,WebHostLib} $out/lib/python/archipelago/
    # Will be copied to the user directory on first webhost launch, needs to be named config.yaml
    mv 'docs/webhost configuration sample.yaml' $out/lib/python/archipelago/config.yaml

    pushd $out/lib/python/archipelago
    # add shebang to all python scripts in root
    for f in *.py
    do
      sed -i '1 i #!/usr/bin/env python' $f
      chmod +x $f
    done
    popd

    ln $out/lib/python/archipelago/Launcher.py $out/bin/archipelago
    chmod +x $out/bin/archipelago

    ln $out/lib/python/archipelago/WebHost.py $out/bin/archipelago-webhost
    chmod +x $out/bin/archipelago-webhost

    # Need some extra directories and symlinks so things work correctly
    ln -s $out/lib/python/archipelago/data $out/bin/data

    # Will not launch from PATH, requires it to be symlinked instead.
    ln -s ${lib.getExe sni} $out/lib/python/archipelago/SNI
    mkdir $out/lib/python/archipelago/EnemizerCLI
    ln -s ${lib.getExe enemizer} $out/lib/python/archipelago/EnemizerCLI/EnemizerCLI.Core

    patchShebangs $out/lib/python/archipelago/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "archipelago";
      desktopName = "Archipelago";
      comment = "Multi-Game Randomizer and Server";
      exec = "archipelago";
      type = "Application";
      categories = [ "Game" ];
      icon = "Archipelago";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Game Randomizer and Server";
    homepage = "https://archipelago.gg";
    changelog = "https://github.com/ArchipelagoMW/Archipelago/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "archipelago";
    maintainers = with lib.maintainers; [ pyrox0 ];
    platforms = lib.platforms.linux;
  };
}

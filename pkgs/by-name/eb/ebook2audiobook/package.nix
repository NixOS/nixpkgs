{
  lib,
  buildFHSEnv,
  fetchFromGitHub,
  makeDesktopItem,
  nix-update-script,
  python3Packages,
}:

let
  version = "26.11.16";

  src = fetchFromGitHub {
    owner = "DrewThomasson";
    repo = "ebook2audiobook";
    tag = "v${version}";
    hash = "sha256-ZAWuvsBQE4MI06pZGA9sKdPHvoI/QyBRl5WBlFXVwH8=";
  };

  # The pip package of upstream: a bootstrap on the standard library only (tools/pip_bootstrap) shipping the app
  # files as data. Its ebook2audiobook command copies them to ~/ebook2audiobook (or $E2A_HOME) and runs the
  # launcher there, which installs python, torch for the detected GPU and the tts engines at first run.
  ebook2audiobook-unwrapped = python3Packages.buildPythonApplication {
    pname = "ebook2audiobook-unwrapped";
    inherit version src;
    pyproject = true;

    build-system = [ python3Packages.setuptools ];

    # the app files are copied out of the store and run by the launcher with its own python: shipped verbatim
    dontPatchShebangs = true;

    pythonImportsCheck = [ "ebook2audiobook.bootstrap" ];

    meta = {
      description = "Bootstrap of ebook2audiobook carrying its app files (unwrapped)";
      homepage = "https://github.com/DrewThomasson/ebook2audiobook";
      license = lib.licenses.asl20;
      mainProgram = "ebook2audiobook";
    };
  };

  desktopItem = makeDesktopItem {
    name = "ebook2audiobook";
    desktopName = "ebook2audiobook";
    comment = "Convert eBooks to audiobooks with chapters and metadata";
    exec = "ebook2audiobook";
    icon = "ebook2audiobook";
    terminal = true;
    categories = [
      "AudioVideo"
      "Audio"
      "Utility"
    ];
  };
in
buildFHSEnv {
  pname = "ebook2audiobook";
  inherit version;

  targetPkgs =
    pkgs: with pkgs; [
      # HOST_PROGRAMS of the launcher: with all of them found it never calls a package manager
      calibre
      cargo
      cmake
      curl
      espeak-ng
      ffmpeg
      libxcb-cursor
      mediainfo
      nodejs
      pkg-config
      rustc
      sox
      # e2a downloads the traineddata of each language it reads to its own TESSDATA_PREFIX (models/tessdata)
      (tesseract.override { enableLanguages = [ "eng" ]; })
      uv

      # used by the launcher, the device probe and the python packages built from source
      gcc
      git
      gnumake
      netcat-openbsd
      pciutils
      procps
      wget
      xdg-user-dirs
      xdg-utils

      # shared libraries of the PyPI wheels, as in the Dockerfile
      fontconfig
      freetype
      glib
      libGL
      libsndfile
      libx11
      libxcb
      libxext
      libxkbcommon
      libxrender
      nss
      vulkan-loader
      zlib
    ];

  profile = ''
    # this package ships the menu entry: the launcher must not write its own, which would run it outside this env
    export E2A_NO_DESKTOP_ENTRY=1
  '';

  runScript = lib.getExe ebook2audiobook-unwrapped;

  extraInstallCommands = ''
    install -Dm644 ${desktopItem}/share/applications/ebook2audiobook.desktop -t $out/share/applications
    for size in 16 24 32 48 64 128 256; do
      install -Dm644 ${src}/tools/icons/linux/icon-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/ebook2audiobook.png
    done
    install -Dm644 ${src}/tools/icons/linux/appIcon.svg $out/share/icons/hicolor/scalable/apps/ebook2audiobook.svg
  '';

  passthru = {
    inherit ebook2audiobook-unwrapped;
    updateScript = nix-update-script { attrPath = "ebook2audiobook.ebook2audiobook-unwrapped"; };
  };

  meta = {
    description = "Convert eBooks to audiobooks with chapters and metadata";
    longDescription = ''
      Converts eBooks (epub, mobi, azw3, pdf, docx, txt and more) to audiobooks with chapters and metadata,
      with dozens of TTS engines, voice cloning and 1100+ languages, from a web GUI or the command line.

      Runs the upstream launcher in an FHS environment. Like upstream, it manages its own runtime in
      ~/ebook2audiobook (or $E2A_HOME): on first run it installs python with uv, the PyTorch wheels
      matching the detected GPU (CUDA, ROCm, XPU, Vulkan or CPU) and the python packages, then downloads
      the TTS models on demand. These runtime components are not part of this package.

      Crash reports are on by default (anonymized, sent to the maintainers): DO_NOT_TRACK=1 turns them off.

      ebook2audiobook --uninstall removes that folder.
    '';
    homepage = "https://github.com/DrewThomasson/ebook2audiobook";
    changelog = "https://github.com/DrewThomasson/ebook2audiobook/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ robert-mcdowell ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "ebook2audiobook";
  };
}

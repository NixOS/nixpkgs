{
  lib,
  python3Packages,
  fetchFromGitLab,
  copyDesktopItems,
  makeDesktopItem,
  buildFHSEnv,
}:

let
  unwrapped = python3Packages.buildPythonApplication (finalAttrs: {
    pname = "rvgl-launcher-unwrapped";
    version = "0.1.23.1030a4";
    pyproject = true;

    src = fetchFromGitLab {
      owner = "re-volt";
      repo = "rvgl-launcher";
      tag = finalAttrs.version;
      hash = "sha256-F/NyRE81CgHkJx2Wf7cZ8r8s8d5Pzv/O2XlGvyX+1rk=";
    };

    build-system = with python3Packages; [ setuptools ];

    dependencies = with python3Packages; [
      wxpython
      requests
      appdirs
      packaging
    ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace-fail "'wx'" "'wxPython'"
    '';

    postInstall = ''
      install -Dm755 rvgl_launcher.py $out/bin/rvgl-launcher
      install -Dm644 icons/icon.png $out/share/pixmaps/rvgl-launcher.png
    '';

    nativeBuildInputs = [ copyDesktopItems ];

    desktopItems = [
      (makeDesktopItem {
        name = "rvgl-launcher";
        desktopName = "RVGL Launcher";
        icon = "rvgl-launcher";
        exec = "rvgl-launcher";
        comment = "Launcher and package manager for RVGL";
        categories = [ "Game" ];
      })
    ];

    meta = {
      description = "Launcher and package manager for RVGL";
      longDescription = "RVGL Launcher is a cross-platform installer, launcher and package manager for RVGL";
      homepage = "https://re-volt.gitlab.io/rvgl-launcher";
      downloadPage = "https://gitlab.com/re-volt/rvgl-launcher";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ andrewfield ];
      mainProgram = "rvgl-launcher";
      platforms = lib.platforms.linux;
    };
  });

in
buildFHSEnv {
  name = "rvgl-launcher";
  version = unwrapped.version;

  runScript = "rvgl-launcher";

  targetPkgs =
    pkgs: with pkgs; [
      unwrapped

      p7zip

      SDL2
      SDL2_image
      libvorbis
      fluidsynth
      gtk3
    ];

  passthru = {
    unwrapped = unwrapped;
  };

  meta = unwrapped.meta;
}

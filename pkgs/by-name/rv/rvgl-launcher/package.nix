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
    version = "0.1.23.1030a4-rev1";
    pyproject = true;

    src = fetchFromGitLab {
      owner = "re-volt";
      repo = "rvgl-launcher";
      tag = finalAttrs.version;
      hash = "sha256-Xq8gFE8rWMwufvZL5ZaWXbQ/Ls6nPGgmU3PjzFeQOuM=";
    };

    strictDeps = true;
    __structuredAttrs = true;

    build-system = with python3Packages; [ setuptools ];

    dependencies = with python3Packages; [
      wxpython
      requests
      appdirs
      packaging
    ];

    postInstall = ''
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
(buildFHSEnv {
  # The launcher works well with the unwrapped section but the game itself when launched seems to require an FHS environment.
  pname = "rvgl-launcher";
  inherit (unwrapped) version meta;

  runScript = "rvgl-launcher";

  targetPkgs =
    pkgs: with pkgs; [
      unwrapped

      p7zip # Only needed by the actual game when launched, to manage the RVGL packages the game itself uses.

      SDL2
      SDL2_image
      libvorbis
      fluidsynth
      gtk3
    ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${unwrapped}/share/applications/rvgl-launcher.desktop $out/share/applications/rvgl-launcher.desktop
    ln -s ${unwrapped}/share/pixmaps/rvgl-launcher.png $out/share/pixmaps/rvgl-launcher.png
  '';

  passthru = {
    inherit unwrapped;
  };
}).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      strictDeps = true;
      __structuredAttrs = true;
    }
  )

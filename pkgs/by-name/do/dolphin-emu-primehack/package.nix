{
  lib,
  stdenv,
  dolphin-emu,
  fetchFromGitHub,
  fmt_11,

  # passthru
  testers,
  nix-update-script,
}:

# PrimeHack is based on an older Dolphin that fails to build with fmt >= 12.2
(dolphin-emu.override { fmt = fmt_11; }).overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "dolphin-emu-primehack";
    version = "1.0.9";

    src = fetchFromGitHub {
      owner = "shiiion";
      repo = "dolphin";
      tag = finalAttrs.version;
      hash = "sha256-SLTsDHDhBa1d5XOxQRNKBiBpIIntir9D4rhQtQz4w44=";
      fetchSubmodules = true;
      leaveDotGit = true;
      postFetch = ''
        pushd $out
        git rev-parse HEAD 2>/dev/null >$out/COMMIT
        find $out -name .git -print0 | xargs -0 rm -rf
        popd
      '';
    };

    postInstall =
      prevAttrs.postInstall
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        # Rename everything that would collide with dolphin-emu
        mv $out/bin/dolphin-emu $out/bin/dolphin-emu-primehack
        mv $out/bin/dolphin-emu-nogui $out/bin/dolphin-emu-primehack-nogui
        mv $out/bin/dolphin-tool $out/bin/dolphin-tool-primehack
        mv $out/share/man/man6/dolphin-emu.6 $out/share/man/man6/dolphin-emu-primehack.6
        mv $out/share/man/man6/dolphin-emu-nogui.6 $out/share/man/man6/dolphin-emu-primehack-nogui.6
        mv $out/share/icons/hicolor/256x256/apps/dolphin-emu.png $out/share/icons/hicolor/256x256/apps/dolphin-emu-primehack.png
        mv $out/share/icons/hicolor/scalable/apps/dolphin-emu.svg $out/share/icons/hicolor/scalable/apps/dolphin-emu-primehack.svg
        mv $out/share/applications/dolphin-emu.desktop $out/share/applications/dolphin-emu-primehack.desktop
        substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop \
          --replace-fail 'dolphin-emu' 'dolphin-emu-primehack' \
          --replace-fail 'Dolphin Emulator' 'PrimeHack'
      '';

    passthru = prevAttrs.passthru // {
      tests = {
        # Upstream hardcodes the version to PrimeHack
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "dolphin-emu-primehack-nogui --version";
          version = "PrimeHack";
        };
      };
      # Skip pre-release tags
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "^([0-9.]+)$"
        ];
      };
    };

    meta = prevAttrs.meta // {
      homepage = "https://github.com/shiiion/dolphin";
      changelog = "https://github.com/shiiion/dolphin/releases/tag/${finalAttrs.version}";
      description = "Dolphin fork with Metroid Prime Trilogy mouse and keyboard controls";
      mainProgram = if stdenv.hostPlatform.isDarwin then "Primehack" else "dolphin-emu-primehack";
      maintainers = with lib.maintainers; [ mistyttm ];
      teams = with lib.teams; [ gaming ];
    };
  }
)

{
  lib,
  stdenv,
  callPackage,
}:

let
  package = callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) { };
in

package.overrideAttrs (
  finalAttrs: oldAttrs: {
    pname = "ghostty";
    version = "1.0.0";

    outputs = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
      "vim"
    ];

    /**
      Ghostty really likes all of it's resources to be in the same directory, so link them back after we split them

      - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/os/resourcesdir.zig#L11-L52
      - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L745-L750
      - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L818-L834

      terminfo and shell integration should also be installable on remote machines

      ```nix
      { pkgs, ... }: {
        environment.systemPackages = [ pkgs.ghostty.terminfo ];

        programs.bash = {
          interactiveShellInit = ''
            if [[ "$TERM" == "xterm-ghostty" ]]; then
              builtin source ${pkgs.ghostty.shell_integration}/bash/ghostty.bash
            fi
          '';
        };
      }
      ```
    */
    postFixup = ''
      ln -s $man/share/man $resourceDir/man

      mkdir -p $terminfo/share
      mv $resourceDir/terminfo $terminfo/share/terminfo
      ln -s $terminfo/share/terminfo $resourceDir/terminfo

      mv $resourceDir/ghostty/shell-integration $shell_integration
      ln -s $shell_integration $resourceDir/ghostty/shell-integration

      mv $resourceDir/vim/vimfiles $vim
      rmdir $resourceDir/vim
      mkdir -p $out/share
      ln -s $vim $out/share/vim-plugins
    '';

    # Point `nix edit`, etc. to the file that defines the attribute
    pos = builtins.unsafeGetAttrPos "src" finalAttrs;

    meta = lib.recursiveUpdate (oldAttrs.meta or { }) {
      description = "Fast, native, feature-rich terminal emulator pushing modern features";
      longDescription = ''
        Ghostty is a terminal emulator that differentiates itself by being
        fast, feature-rich, and native. While there are many excellent terminal
        emulators available, they all force you to choose between speed,
        features, or native UIs. Ghostty provides all three.
      '';
      homepage = "https://ghostty.org/";
      downloadPage = "https://ghostty.org/download";

      license = lib.licenses.mit;
      mainProgram = "ghostty";
      maintainers = with lib.maintainers; [
        jcollie
        pluiedev
        getchoo
        DimitarNestorov
      ];
      outputsToInstall = [
        "out"
        "man"
        "shell_integration"
        "terminfo"
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
)

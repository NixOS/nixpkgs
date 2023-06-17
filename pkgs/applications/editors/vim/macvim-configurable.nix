{ lib, stdenv, callPackage, vimUtils, buildEnv, makeWrapper }:

let
  macvim = callPackage ./macvim.nix { inherit stdenv; };

  makeCustomizable = macvim: macvim // {
    # configure expects the same args as vimUtils.vimrcFile.
    # This is the same as the value given to neovim.override { configure = … }
    # or the value of vim-full.customize { vimrcConfig = … }
    #
    # Note: Like neovim and vim-full, configuring macvim disables the
    # sourcing of the user's vimrc. Use `customRC = "source $HOME/.vim/vimrc"`
    # if you want to preserve that behavior.
    configure = let
      doConfig = config: let
        vimrcConfig = config // {
          # always source the bundled system vimrc
          beforePlugins = ''
            source $VIM/vimrc
            ${config.beforePlugins or ""}
          '';
        };
      in buildEnv {
        name = macvim.name;
        paths = [ macvim ];
        pathsToLink = [
          "/"
          "/bin"
          "/Applications/MacVim.app/Contents/MacOS"
          "/Applications/MacVim.app/Contents/bin"
        ];
        nativeBuildInputs = [ makeWrapper ];
        # We need to do surgery on the resulting app. We can't just make a wrapper for vim because this
        # is a GUI app. We need to copy the actual GUI executable image as AppKit uses the loaded image's
        # path to locate the bundle. We can use symlinks for other executables and resources though.
        postBuild = ''
          # Replace the Contents/MacOS/MacVim symlink with the original file
          target=$(readlink $out/Applications/MacVim.app/Contents/MacOS/MacVim)
          rm $out/Applications/MacVim.app/Contents/MacOS/MacVim
          cp -a -t $out/Applications/MacVim.app/Contents/MacOS "$target"

          # Wrap the Vim binary for our vimrc
          wrapProgram $out/Applications/MacVim.app/Contents/MacOS/Vim \
            --add-flags "-u ${vimUtils.vimrcFile vimrcConfig}"

          # Replace each symlink in bin/ with the original. Most of them point at other symlinks
          # and we need those original symlinks to point into our new app bundle.
          for prefix in bin Applications/MacVim.app/Contents/bin; do
            for link in $out/$prefix/*; do
              target=$(readlink "$link")
              # don't copy binaries like vimtutor, but we do need mvim
              [ -L "$target" ] || [ "$(basename "$target")" = mvim ] || continue;
              rm "$link"
              cp -a -t $out/$prefix "$target"
            done
          done
        '';
        meta = macvim.meta;
      };
    in lib.makeOverridable (lib.setFunctionArgs doConfig (lib.functionArgs vimUtils.vimrcFile));

    override = f: makeCustomizable (macvim.override f);
    overrideAttrs = f: makeCustomizable (macvim.overrideAttrs f);
  };
in
  makeCustomizable macvim

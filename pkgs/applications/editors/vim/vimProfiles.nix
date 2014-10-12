{ stdenv, lib, pkgs, makeWrapper, vimProfiles ? null, vimDefault ? null }:

let
  mkProfile = profile_name: profile_config:
    pkgs.stdenv.mkDerivation rec {
      name = if isNull profile_name
        then "vim-default"
        else "vimProfile-${profile_name}";
      version = pkgs.vimPlain.version;
      phases = ["buildPhase" "installPhase"];

      buildInputs = [makeWrapper profile_config.buildInputs];
      buildPhase = lib.concatStringsSep "\n" ([ ''mkdir "bin"'' ] ++ [ profile_config.buildCommand ]);
      installPhase = ''
        cp -r . $out
        rm -f $out/env-vars
        '';
      preferLocalBuild = true;
      meta = {
        description = ''
          VimProfile allows to wrap vim with different configurations.
          A configuration is composed by enabling and customizing pre-defined modules.
          A module is a set of vim plugins and vimrc statements that are tightly linked.
          Configurations are hierarchical and can inherit from each other.
          The base of each hierarchy of configurations is a distingued default configuration.
          Enabled vim configurations appear as normal package in nix, and have to be
          installed accordingly.

          The vimProfiles are declared either for system wide installations in
          /etc/nixos/configuration.nix, or for each user in ~/.nixuser/configuration.nix.

          An example for a vim configuration, here the content of ~/.nixuser/configuration.nix:

          { config, pkgs, ... }:
          with pkgs;
          { 
            programs.vim =
              { enable = true;
                leader = " ";
                general.enable = true;
                statusline.enable = true;
                profiles =
                  {  # Haskell configuration
                    hvim =
                      { enable = true;
                        exec = { package = pkgs.vim_configurable; bin = "bin/vim"; };
                        search.enable = true;
                        # leader can be overwritten independently for each module
                        search.leader = "|";
                        text.enable = true;
                        sidebar.enable = true;
                        # overwrite default key binding
                        sidebar.toggleUndo = "<Leader>uu";
                        completion.enable = true;
                        haskell.enable = true;
                      };
                    # graphical Haskell configuration
                    hqvim =
                      { enable = true; 
                        # set the name to call the wrapped vim
                        name = "Hvim";
                        parent = "hvim"; 
                        exec = { package = pkgs.qvim; bin = "bin/qvim"; };
                        # just as an example that inherited modules can also be disabled
                        search.enable = false;
                      };
                    # same configuration as for default, but with qvim
                    qvim =
                      { # don't make that profile installable
                        enable = false;
                        exec = { package = pkgs.qvim; bin = "bin/qvim"; };
                        # if no name attribute is given, the attribute name
                        # of the configuration is taken: "qvim"
                      };
                    # alias declaration for qvim
                    gvim =
                      { enable = true; 
                        # inherit from a configuration by its attribute name
                        # you can inherit from a disabled configuration as well
                        parent = "qvim";
                        # add statement to the generated vimrc; it is inserted
                        # before any module statement
                        vimrc = "" # replace "" with two single quotes
                          " Leader key timeout
                          set tm=2000
                          "";
                      };
                  };
              };
          }

          The declaration above defines the following packages in nix:
          "vimProfile.hvim", "vimProfile.hqvim" and "vimProfile.gvim".
          When the default profile is enabled, it is automatically installed with
          the package "vim".
          An un-wrapped vim package is always available with "vimPlain".
          '';
        maintainers = [ stdenv.lib.maintainers.tstrobel ];
        platforms = stdenv.lib.platforms.unix;
      };
    };
in
  if isNull vimDefault then 
    lib.mapAttrs mkProfile vimProfiles
  else
    mkProfile null vimDefault

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firejail;

  wrappedBins = pkgs.runCommand "firejail-wrapped-binaries"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      # take precedence over non-firejailed versions
      meta.priority = -1;
    }
    ''
      mkdir -p $out/bin
      mkdir -p $out/share/applications
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: value:
      let
        opts = if builtins.isAttrs value
        then value
        else { executable = value; desktop = null; profile = null; extraArgs = []; };
        args = lib.escapeShellArgs (
          opts.extraArgs
          ++ (optional (opts.profile != null) "--profile=${toString opts.profile}")
        );
      in
      ''
        cat <<_EOF >$out/bin/${command}
        #! ${pkgs.runtimeShell} -e
        exec /run/wrappers/bin/firejail ${args} -- ${toString opts.executable} "\$@"
        _EOF
        chmod 0755 $out/bin/${command}

        ${lib.optionalString (opts.desktop != null) ''
          substitute ${opts.desktop} $out/share/applications/$(basename ${opts.desktop}) \
            --replace ${opts.executable} $out/bin/${command}
        ''}
      '') cfg.wrappedBinaries)}
    '';

  wrappedPkgs = map (pkg:
    pkgs.symlinkJoin {
      name = "firejail-" + pkg.name;
      paths = [ pkg ];
      postBuild = ''
        [[ -d "$out/share/applications" ]] && grep -q -R Exec=/ "$out/share/applications" && \
          >&2 echo -e "\033[1mERROR: ${pkg.name} desktop file cannot be firejailed because it specifies an absolute path to the unwrapped binary. Please use wrappedBinaries or better yet fix the ${pkg.name} desktop file in nixpkgs and/or upstream.\033[0m" && exit 1
        for bin in $(find "$out/bin" -type l); do
          oldbin="$(realpath "$bin")"
          rm "$bin"
          cat <<_EOF >"$bin"
        #! ${pkgs.runtimeShell} -e
        exec /run/wrappers/bin/firejail "$oldbin" "\$@"
        _EOF
          chmod 0755 "$bin"
        done
      '';
    }
  ) cfg.wrappedPackages;

in {
  options.programs.firejail = {
    enable = mkEnableOption (lib.mdDoc "firejail");

    wrappedBinaries = mkOption {
      type = types.attrsOf (types.either types.path (types.submodule {
        options = {
          executable = mkOption {
            type = types.path;
            description = lib.mdDoc "Executable to run sandboxed";
            example = literalExpression ''"''${lib.getBin pkgs.firefox}/bin/firefox"'';
          };
          desktop = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mkDoc ".desktop file to modify. Only necessary if it uses the absolute path to the executable.";
            example = literalExpression ''"''${pkgs.firefox}/share/applications/firefox.desktop"'';
          };
          profile = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mdDoc "Profile to use";
            example = literalExpression ''"''${pkgs.firejail}/etc/firejail/firefox.profile"'';
          };
          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [];
            description = lib.mdDoc "Extra arguments to pass to firejail";
            example = [ "--private=~/.firejail_home" ];
          };
        };
      }));
      default = {};
      example = literalExpression ''
        {
          firefox = {
            executable = "''${lib.getBin pkgs.firefox}/bin/firefox";
            profile = "''${pkgs.firejail}/etc/firejail/firefox.profile";
          };
          mpv = {
            executable = "''${lib.getBin pkgs.mpv}/bin/mpv";
            profile = "''${pkgs.firejail}/etc/firejail/mpv.profile";
          };
        }
      '';
      description = lib.mdDoc ''
        Wrap the binaries in firejail and place them in the global path.
      '';
    };

    wrappedPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExample ''
        [ pkgs.mpv ]
      '';
      description = ''
        Put a package into <option>systemPackages</option>,
        but wrap its binaries with firejail.
        Compared to <option>wrappedBinaries</option>,
        this e.g. has the advantage of providing desktop entries and icons.
        However, you should be careful about using these packages'
        libraries as they will not be wrapped.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.firejail =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${lib.getBin pkgs.firejail}/bin/firejail";
      };

    environment.systemPackages = [ pkgs.firejail ] ++ [ wrappedBins ] ++ wrappedPkgs;
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}

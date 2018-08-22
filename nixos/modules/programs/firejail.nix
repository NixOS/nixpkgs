{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firejail;

  wrappedBins = pkgs.stdenv.mkDerivation rec {
    name = "firejail-wrapped-binaries";
    buildCommand = ''
      mkdir -p $out/bin
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (command: binary: ''
      cat <<_EOF >$out/bin/${command}
      #!${pkgs.stdenv.shell} -e
      /run/wrappers/bin/firejail ${binary} "\$@"
      _EOF
      chmod 0755 $out/bin/${command}
      '') cfg.wrappedBinaries)}
    '';
  };

  wrappedPkgs = map (pkg:
    pkgs.symlinkJoin {
      name = "firejail-" + pkg.name;
      paths = [ pkg ];
      buildInputs = with pkgs; [ tree ];
      postBuild = ''
        for bin in $(find "$out/bin" -type l); do
        oldbin="$(readlink "$bin")" 
        rm "$bin"
        cat <<_EOF >"$bin"
        #!${pkgs.stdenv.shell} -e
        /run/wrappers/bin/firejail "$oldbin" "\$@"
        _EOF
        chmod 0755 "$bin"
        done
      '';
    }
  ) cfg.wrappedPackages;

in {
  options.programs.firejail = {
    enable = mkEnableOption "firejail";

    wrappedBinaries = mkOption {
      type = types.attrs;
      default = {};
      example = literalExample ''
        {
          mpv = "${pkgs.mpv}/bin/mpv";
        }
      '';
      description = ''
        Wrap the binaries in firejail and place them in the global path.
        </para>
        <para>
        You will get file collisions if you put the actual application binary in
        the global environment and applications started via .desktop files are
        not wrapped if they specify the absolute path to the binary.
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
    security.wrappers.firejail.source = "${lib.getBin pkgs.firejail}/bin/firejail";

    environment.systemPackages = [ wrappedBins ] ++ wrappedPkgs;
  };

  meta.maintainers = with maintainers; [ peterhoeg ];
}

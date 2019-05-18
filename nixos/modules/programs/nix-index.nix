{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nix-index;

  # Wrap nix-locate to use cache
  nix-locate = pkgs.runCommand "nix-locate" {
    buildInputs = [pkgs.makeWrapper];
  } ''
mkdir -p $out/bin
makeWrapper ${pkgs.nix-index}/bin/nix-locate $out/bin/nix-locate \
  --add-flags "-d ${cache}"
  '';

  # Note that this requires internet access to work.
  cache = pkgs.runCommand "nix-index" {
    buildInputs = [ pkgs.nix-index config.nix.package ];
    NIX_REMOTE = builtins.getEnv "NIX_REMOTE";
  } ''
mkdir -p $out
nix-index -d $out -f ${toString pkgs.path}
  '';

  cnf = ''
    # do not run when inside a Pipe
    if ! [ -t 1 ]; then
        >&2 echo "$1: command not found"
        return 127
    fi

    toplevel=nixos
    cmd=$1
    attrs=$(${pkgs.nix-index}/bin/nix-locate -d ${cache} --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")
    len=$(echo -n "$attrs" | grep -c "^")

    case $len in
        0)
            >&2 echo "$cmd: command not found"
            ;;
        1)
            # if only 1 package provides this, then we can invoke it
            # without asking the users if they have opted in with one
            # of 2 environment variables

            # they are based on the ones found in
            # command-not-found.sh:

            #   NIX_AUTO_INSTALL : install the missing command into the
            #                      user’s environment
            #   NIX_AUTO_RUN     : run the command transparently inside of
            #                      nix shell

            # these will not return 127 if they worked correctly

            if ! [ -z "$NIX_AUTO_INSTALL" ]; then
                >&2 cat <<EOF
The program '$cmd' is currently not installed. It is provided by
the package '$toplevel.$attrs', which I will now install for you.
EOF
                nix-env -iA $toplevel.$attrs
                if [ "$?" -eq 0 ]; then
                    $@ # TODO: handle pipes correctly if AUTO_RUN/INSTALL is possible
                    return $?
                else
                    >&2 cat <<EOF
Failed to install $toplevel.attrs.
$cmd: command not found
EOF
                fi
            elif ! [ -z "$NIX_AUTO_RUN" ]; then
                nix-build --no-out-link -A $attrs "<$toplevel>"
                if [ "$?" -eq 0 ]; then
                    # how nix-shell handles commands is weird
                    # $(echo $@) is need to handle this
                    nix-shell -p $attrs --run "$(echo $@)"
                    return $?
                else
                    >&2 cat <<EOF
Failed to install $toplevel.attrs.
$cmd: command not found
EOF
                fi
            else
                >&2 cat <<EOF
The program '$cmd' is currently not installed. You can install it
by typing:
  nix-env -iA $toplevel.$attrs
EOF
            fi
            ;;
        *)
            >&2 cat <<EOF
The program '$cmd' is currently not installed. It is provided by
several packages. You can install it by typing one of the following:
EOF

            # ensure we get each element of attrs
            # in a cross platform way
            while read attr; do
                >&2 echo "  nix-env -iA $toplevel.$attr"
            done <<< "$attrs"
            ;;
    esac
'';

in {
  options = {
    programs.nix-index = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable generation of nix-index database and
          command-not-found support.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.bash.interactiveShellInit = ''
command_not_found_handle () {
  ${cnf}
  return 127
}
    '';

    programs.zsh.interactiveShellInit = ''
command_not_found_handler () {
  ${cnf}
  return 127
}
    '';

    environment.systemPackages = [ nix-locate ];

    programs.command-not-found.enable = false;
  };

}

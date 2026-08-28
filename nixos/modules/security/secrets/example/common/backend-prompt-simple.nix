# An example interactive prompt backend written in Bash.
let
  mkScript =
    name: text: pkgs:
    pkgs.lib.getExe (
      pkgs.writeShellApplication {
        inherit name text;
        runtimeInputs = [ pkgs.coreutils ];
        checkPhase = "";
      }
    );
in
{
  secrets.backends.prompt.simple.ask = mkScript "prompt" ''
    out=''${out:?} # Make shellcheck happy

    prompt="$4"
    if [[ ! -z "$5" ]]; then
      prompt="$prompt ($5)"
    fi

    if [[ "$3" == "line" ]]; then
      read -rp "$prompt: " text
      echo -n "$text" > "$out"
    elif [[ "$3" == "hidden" ]]; then
      read -srp "$prompt: " text
      echo ""
      echo -n "$text" > "$out"
    elif [[ "$3" == "multiline" ]]; then
      echo "<$prompt>" > "$out"
      $EDITOR "$out"
    else
      exit 1
    fi
  '';
}

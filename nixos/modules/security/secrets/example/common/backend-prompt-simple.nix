# An example interactive prompt backend written in Bash.
{ lib, ... }:
{
  secrets.backends.prompt.simple.ask =
    pkgs:
    pkgs.writeShellScript "prompt-simple" ''
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}:$PATH"
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

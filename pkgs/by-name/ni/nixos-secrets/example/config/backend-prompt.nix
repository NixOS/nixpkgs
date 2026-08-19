let
  mkScript =
    name: text: pkgs:
    pkgs.lib.getExe (
      pkgs.writeShellApplication {
        inherit name text;
        runtimeInputs = [ pkgs.coreutils ];
      }
    );
in
{
  secrets = {
    defaultPromptBackend = "simple";
    promptBackends.simple.script = mkScript "prompt" ''
      out=''${out:?} # Make shellcheck happy

      prompt="$2"
      if [[ ! -z "$3" ]]; then
        prompt="$prompt ($3)"
      fi

      if [[ "$1" == "line" ]]; then
        read -rp "$prompt: " text
        echo -n "$text" > "$out"
      elif [[ "$1" == "hidden" ]]; then
        read -srp "$prompt: " text
        echo ""
        echo -n "$text" > "$out"
      elif [[ "$1" == "multiline" ]]; then
        echo "<$prompt>" > "$out"
        $EDITOR "$out"
      else
        exit 1
      fi
    '';
  };
}

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
  vars = {
    defaultPromptBackend = "simple";
    promptBackends.simple.script = mkScript "prompt" ''
      out=''${out:?} # Make shellcheck happy
      if [[ "$1" == "line" ]]; then
        read -rp "$2: " text
        echo -n "$text" > "$out"
      elif [[ "$1" == "hidden" ]]; then
        read -srp "$2: " text
        echo ""
        echo -n "$text" > "$out"
      elif [[ "$1" == "multiline" ]]; then
        echo "<$2>" > "$out"
        $EDITOR "$out"
      else
        exit 1
      fi
    '';
  };
}

# A series of interactive prompt examples written in Bash.
{ lib, ... }:
let
  preamble = pkgs: ''
    export PATH="${lib.makeBinPath [ pkgs.coreutils ]}:$PATH"
    out=''${out:?} # Make shellcheck happy

    prompt="$3"
    if [[ ! -z "$4" ]]; then
      prompt="$prompt ($4)"
    fi
  '';
in
{
  secrets.backends.prompt.read-line.ask =
    { pkgs, ... }:
    pkgs.writeShellScript "prompt-line" ''
      ${preamble pkgs}
      read -rp "$prompt: " text
      echo -n "$text" > "$out"
    '';

  secrets.backends.prompt.read-hidden.ask =
    { pkgs, ... }:
    pkgs.writeShellScript "prompt-hidden" ''
      ${preamble pkgs}
      read -srp "$prompt: " text
      echo ""
      echo -n "$text" > "$out"
    '';

  secrets.backends.prompt.editor.ask =
    { pkgs, ... }:
    pkgs.writeShellScript "prompt-editor" ''
      ${preamble pkgs}
      echo "<$prompt>" > "$out"
      $EDITOR "$out"
    '';
}

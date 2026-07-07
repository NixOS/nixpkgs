let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
  root = "/tmp/vars-demo";
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
    defaultPromptBackend = "example";
    promptBackends.example.script = mkScript "prompt" ''
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

    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get = mkScript "get" ''
        out=''${out:?} # Make shellcheck happy
        cat ${root}/generators/"$1"/files/"$2" > "$out"
      '';
      set = mkScript "set" ''
        in=''${in:?} # Make shellcheck happy
        mkdir -p ${root}/generators/"$1"/files/
        cat "$in" > ${root}/generators/"$1"/files/"$2"
      '';
      exists = mkScript "exists" ''
        if [[ ! -f ${root}/generators/"$1"/files/"$2" ]]; then
          exit 42
        fi
      '';

      delete = mkScript "delete" ''
        rm -rf ${root}/generators/"$1"/files/"$2"
      '';

      # This example showcases that scripts can be written in any language
      list =
        pkgs:
        pkgs.writers.writePython3 "list" { } ''
          from pathlib import Path
          base = Path("${root}/generators")
          if base.exists():
              for generator in base.iterdir():
                  for file in (generator / "files").iterdir():
                      print(f"{generator.name} {file.name}")
        '';

      fixup = mkScript "fixup" "";

      deploy = noop;
    };

    prompts.example.description = "Your name";
    prompts.example.type = "multiline";

    generators.example = {
      prompts = [ "example" ];
      files.example = { };
      script = mkScript "gen-example" ''
        # Make shellcheck happy
        out=''${out:?}         
        prompts=''${prompts:?}
        echo "Hewwo $(cat "$prompts/example")!" > "$out/example"
      '';
    };

    generators.derived = {
      dependencies = [ "example" ];
      files.derived = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-derived" ''
          ${pkgs.coreutils}/bin/cat $in/example/example \
            | ${pkgs.lib.getExe pkgs.cowsay} > $out/derived
        '';
    };
  };
}

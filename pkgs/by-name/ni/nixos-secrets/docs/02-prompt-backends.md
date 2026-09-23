## Prompt backends

Before jumping in to the more complex idea of store backends, we'll go over how one can specify prompt backends. Prompt backends require a single `ask` script, which is responsible for asking the user for information. The script is given five arguments, and must write the resulting value to `$out`:

1. The secret name (`user` in the previous example)
2. The prompt name (`name` in the previous example)
3. The prompt type
4. The prompt label
5. The prompt description

The first two arguments are not necessarily meant to be displayed to the user. Instead, they're provided for use in scenarios like testing, such that the backend can identify precisely which prompt it is currently answering to (since labels & descriptions need not be unique!).

A very simple prompt backend would look something like this:

```nix
{
  secrets.backends.prompt.simple.ask =
    pkgs:
    pkgs.writeScript "simple-prompt" ''
      #!/bin/sh
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"

      # We do not care about $1 (the secret name) nor $2 (the prompt name).

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
```

One thing to note is that prompt (and by extension, store) backends will not be sandboxed (unlike generator scripts).

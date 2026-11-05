## Prompt backends

Before jumping in to the more complex idea of store backends, we'll go over how one can specify prompt backends. Prompt backends require a single `ask` script, which is responsible for asking the user for information. The script is given five arguments, and must write the resulting value to `$out`:

1. The secret name (`user` in the previous example)
2. The prompt name (`name` in the previous example)
3. The prompt label
4. The prompt description

The first two arguments are not necessarily meant to be displayed to the user. Instead, they're provided for use in scenarios like testing, such that the backend can identify precisely which prompt it is currently answering to (since labels & descriptions need not be unique!).

A very simple prompt backend would look something like this:

```nix
{
  secrets.backends.prompt.simple.ask =
    { pkgs, ... }:
    pkgs.writeScript "simple-prompt" ''
      #!/bin/sh
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"

      # We do not care about $1 (the secret name) nor $2 (the prompt name).

      prompt="$3"
      if [[ ! -z "$4" ]]; then
        prompt="$prompt ($4)"
      fi

      read -rp "$prompt: " text
      echo -n "$text" > "$out"
    '';
}
```

Prompt (and by extension, store) backends are not sandboxed (unlike generator scripts).

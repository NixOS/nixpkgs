{
  descent3-unwrapped,
  lib,
  makeBinaryWrapper,
  runCommand,
}:

runCommand "descent3-${descent3-unwrapped.version}"
  {
    pname = "descent3";
    inherit (descent3-unwrapped) version;
    nativeBuildInputs = [ makeBinaryWrapper ];
    passthru.unwrapped = descent3-unwrapped;

    meta = descent3-unwrapped.meta // {
      # The code that produces the wrapper is in the Nixpkgs repo, and the
      # Nixpkgs repo is MIT Licensed.
      license = [ lib.licenses.mit ];
      longDescription = ''
        Playing Descent 3 using the Nix package manager is a little bit awkward
        at the moment. This wrapper makes it slightly less awkward. Here’s how
        you use this wrapper:

        1. Install the `descent3` package, or start an ephemeral shell with the
        `descent3` package.

        2. Find the documentation folder for `descent3-unwrapped` by running this
        command:

            ```bash
            nix-instantiate --eval --expr '(import <nixpkgs> { }).descent3-unwrapped + "/share/doc/Descent3"'
            ```

        3. Open `<descent3-unwrapped-doc-folder>/USAGE.md`.

        4. Follow steps 1–6 of Descent 3’s usage instructions.

        5. Change directory into the `D3-open-source` folder:

          ```bash
          cd <path-to-D3-open-source>
          ```

        6. Start Descent 3 by running this command:

            ```bash
            Descent3
            ```
      '';
    };
  }
  ''
    mkdir --parents "$out/bin"
    descent3_unwrapped=${lib.strings.escapeShellArg descent3-unwrapped}
    makeBinaryWrapper \
      "$descent3_unwrapped/bin/Descent3" \
      "$out/bin/Descent3" \
      --append-flags -additionaldir \
      --append-flags "$descent3_unwrapped/share"
  ''

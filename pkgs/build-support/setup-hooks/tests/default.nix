{
  stdenv,
}:
{
  # tests based on bootstrap tools to prevent rebuilding stdenv on each change

  parallel =
    (derivation {
      name = "test-parallel-hook";
      system = stdenv.system;
      builder = "${stdenv.bootstrapTools}/bin/bash";
      PATH = "${stdenv.bootstrapTools}/bin";
      args = [
        "-c"
        ''
          . ${../parallel.sh}
          . ${./test-parallel.sh}
        ''
      ];
    })
    // {
      meta = { };
    };

  make-symlinks-relative =
    (derivation {
      name = "test-make-symlinks-relative";
      system = stdenv.system;
      builder = "${stdenv.bootstrapTools}/bin/bash";
      initialPath = "${stdenv.bootstrapTools}";
      outputs = [
        "out"
        "out2"
      ];
      args = [
        "-c"
        ''
          set -euo pipefail
          . ${../../../stdenv/generic/setup.sh}
          . ${../parallel.sh}
          . ${../make-symlinks-relative.sh}

          mkdir -p $out $out2

          # create symlink targets
          touch $out/target $out2/target

          # link within out
          ln -s $out/target $out/linkToOut

          # link across different outputs
          ln -s $out2/target $out/linkToOut2

          # broken link
          ln -s $out/does-not-exist $out/brokenLink

          # call hook
          _makeSymlinksRelative

          # verify link within out became relative
          echo "readlink linkToOut: $(readlink $out/linkToOut)"
          if test "$(readlink $out/linkToOut)" != 'target'; then
            echo "Expected relative link, got: $(readlink $out/linkToOut)"
            exit 1
          fi

          # verify link across outputs is still absolute
          if test "$(readlink $out/linkToOut2)" != "$out2/target"; then
            echo "Expected absolute link, got: $(readlink $out/linkToOut2)"
            exit 1
          fi

          # verify broken link was made relative
          if test "$(readlink $out/brokenLink)" != 'does-not-exist'; then
            echo "Expected relative broken link, got: $(readlink $out/brokenLink)"
            exit 1
          fi
        ''
      ];
    })
    // {
      meta = { };
    };
}

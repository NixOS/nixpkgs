{
  runCommand,
  patchShebangs,
  coreutils,
  bash,
}:

{
  basic =
    runCommand "patch-shebangs-test-basic"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo '#!/bin/bash' > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q '/nix/store/.*/bash' bin/test && touch $out
      '';

  env-shebang =
    runCommand "patch-shebangs-test-env"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
          bash
        ];
      }
      ''
        mkdir -p bin && echo '#!/usr/bin/env bash' > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q '/nix/store/.*/bash' bin/test && ! grep -q '/usr/bin/env' bin/test && touch $out
      '';

  env-S-flag =
    runCommand "patch-shebangs-test-env-S"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
          bash
        ];
      }
      ''
        mkdir -p bin && echo '#!/usr/bin/env -S bash --posix' > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q '/nix/store/.*/env -S /nix/store/.*/bash --posix' bin/test && touch $out
      '';

  preserves-args =
    runCommand "patch-shebangs-test-args"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
          bash
        ];
      }
      ''
        mkdir -p bin && echo '#!/bin/bash -eu' > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q '/nix/store/.*/bash -eu' bin/test && touch $out
      '';

  ignores-nix-store =
    runCommand "patch-shebangs-test-ignores-store"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo "#!$NIX_STORE/aaaa-bash/bin/bash" > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q "^#!$NIX_STORE/aaaa-bash/bin/bash" bin/test && touch $out
      '';

  update-flag =
    runCommand "patch-shebangs-test-update"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo "#!$NIX_STORE/aaaa-bash/bin/bash" > bin/test && chmod +x bin/test
        patch-shebangs --update --build bin
        grep -q '/nix/store/.*/bash' bin/test && ! grep -q 'aaaa-bash' bin/test && touch $out
      '';

  read-only =
    runCommand "patch-shebangs-test-readonly"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo '#!/bin/bash' > bin/test && chmod 555 bin/test
        patch-shebangs --build bin
        grep -q '/nix/store/.*/bash' bin/test && [ "$(stat -c %a bin/test)" = "555" ] && touch $out
      '';

  preserves-timestamp =
    runCommand "patch-shebangs-test-timestamp"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo '#!/bin/bash' > bin/test && chmod +x bin/test
        touch -t 200001010000 bin/test && orig=$(stat -c %Y bin/test)
        patch-shebangs --build bin
        [ "$(stat -c %Y bin/test)" = "$orig" ] && touch $out
      '';

  nested-dirs =
    runCommand "patch-shebangs-test-nested"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin/sub/deep
        echo '#!/bin/bash' > bin/a && echo '#!/bin/bash' > bin/sub/b && echo '#!/bin/bash' > bin/sub/deep/c
        chmod +x bin/a bin/sub/b bin/sub/deep/c
        patch-shebangs --build bin
        grep -q '/nix/store/.*/bash' bin/a && grep -q '/nix/store/.*/bash' bin/sub/b && grep -q '/nix/store/.*/bash' bin/sub/deep/c && touch $out
      '';

  non-executable-ignored =
    runCommand "patch-shebangs-test-nonexec"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo '#!/bin/bash' > bin/test && chmod 644 bin/test
        patch-shebangs --build bin
        grep -q '^#!/bin/bash' bin/test && touch $out
      '';

  unknown-interpreter =
    runCommand "patch-shebangs-test-unknown"
      {
        nativeBuildInputs = [
          patchShebangs
          coreutils
        ];
      }
      ''
        mkdir -p bin && echo '#!/usr/bin/unknowncmd' > bin/test && chmod +x bin/test
        patch-shebangs --build bin
        grep -q '^#!/usr/bin/unknowncmd' bin/test && touch $out
      '';
}

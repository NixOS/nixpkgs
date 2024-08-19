/*
  To run:

      cd nixpkgs
      nix build --file . tests.trivial-builders.applyPatches

  or to run an individual test case

      cd nixpkgs
      nix build --file . tests.trivial-builders.applyPatches.foo
*/
{
  lib,
  testers,
  runCommand,
  applyPatches,
  writeText,
  writeTextDir,
  emptyDirectory,
}:
lib.recurseIntoAttrs {
  defaultArguments = testers.testEqualContents {
    assertion = "applyPatches succeeds without arguments except for src";
    expected = emptyDirectory;
    actual = applyPatches { src = emptyDirectory; };
  };

  emptyArguments = testers.testEqualContents {
    assertion = "applyPatches succeeds with empty arguments";
    expected = emptyDirectory;
    actual = applyPatches {
      src = emptyDirectory;
      patches = [ ];
      postPatch = "";
      prePatch = "";
    };
  };

  missingPatch = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [ "missing.patch" ];
  });

  patchWithIncorrectFormat = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [ (writeText "invalid.patch" "invalid patch content") ];
  });

  patchWithFlags = testers.testEqualContents {
    assertion = "applyPatches applies patch with -p0 flag";
    expected = writeTextDir "content.txt" "Patched content\n";
    actual = applyPatches {
      src = writeTextDir "content.txt" "Original content\n";
      patches = [
        (writeText "content.patch" ''
          --- content.txt
          +++ content.txt
          @@ -1 +1 @@
          -Original content
          +Patched content
        '')
      ];
      patchFlags = [ "-p0" ];
    };
  };

  patchWithEmptyDiff = testers.testEqualContents {
    assertion = "applyPatches handles patch with empty diff";
    expected = writeTextDir "file.txt" "original content";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content";
      patches = [
        (writeText "empty-patch.patch" ''
          diff --git a/file.txt b/file.txt
          index e69de29..d20e9cd 100644
          --- a/file.txt
          +++ b/file.txt
        '')
      ];
    };
  };

  patchWithIncorrectFilePath = testers.testBuildFailure (applyPatches {
    src = writeTextDir "file1.txt" "content";
    patches = [
      (writeText "incorrect-path.patch" ''
        --- a/file2.txt
        +++ b/file2.txt
        @@ -1 +1 @@
        -old content
        +new content
      '')
    ];
  });

  alreadyAppliedPatch = testers.testBuildFailure (applyPatches {
    src = writeTextDir "file.txt" "patched content\n";
    patches = [
      (writeText "$out/patch.patch" ''
        --- a/file.txt
        +++ b/file.txt
        @@ -1 +1 @@
        -original content
        +patched content
      '')
    ];
  });

  patchFromUnpackedSource = testers.testEqualContents {
    assertion = "applyPatches uses patches from working directory with unpacked source";
    expected = writeTextDir "config.toml" ''
      key1 = "value1"
      key2 = "value2"
    '';
    actual = applyPatches {
      src = runCommand "patchFromUnpackedSource-src" { } ''
        mkdir -p "$out"
        cat >"$out/config.toml" <<'EOF'
        key1 = "value1"
        # Missing key2
        EOF
        cat >"$out/config.patch" <<'EOF'
        --- a/config.toml
        +++ b/config.toml
        @@ -1,2 +1,2 @@
         key1 = "value1"
        -# Missing key2
        +key2 = "value2"
        EOF
      '';
      patches = [ "config.patch" ];
      postPatch = ''
        rm config.patch
      '';
    };
  };

  patchWithGitExtendedHeaders = testers.testEqualContents {
    assertion = "applyPatches supports patches with Git extended headers";
    expected = runCommand "patchWithGitExtendedHeaders-expected" { } ''
      mkdir -p "$out"
      cat >"$out/config.toml" <<'EOF'
      key1 = "value1"
      key2 = "value2"
      EOF
      cat >"$out/data.json" <<'EOF'
      {"value": 42}
      EOF
    '';
    actual = applyPatches {
      src = runCommand "patchWithGitExtendedHeaders-src" { } ''
        mkdir -p "$out"
        cat >"$out/config.toml" <<'EOF'
        key1 = "value1"
        EOF
        cat >"$out/old-data.json" <<'EOF'
        {"old_value":37}
        EOF
      '';
      patches = [
        (writeText "0001-add-key2-to-config.patch" ''
          diff --git a/config.toml b/config.toml
          index e69de29..d20e9cd 100644
          --- a/config.toml
          +++ b/config.toml
          @@ -1 +1,2 @@
           key1 = "value1"
          +key2 = "value2"
        '')
        (writeText "0002-rename-and-update-data.patch" ''
          diff --git a/old-data.json b/data.json
          similarity index 25 dissimilarity index 75
          rename from old-data.json
          rename to data.json
          --- a/old-data.json
          +++ b/data.json
          @@ -1 +1 @@
          -{"old_value":37}
          +{"value": 42}
        '')
      ];
    };
  };

  emptyPatchSeries = testers.testEqualContents {
    assertion = "applyPatches succeeds with empty patch series file";
    expected = emptyDirectory;
    actual = applyPatches {
      src = emptyDirectory;
      patches = [ (writeTextDir "series" "") ];
    };
  };

  patchSeriesWithMultiplePatches = testers.testEqualContents {
    assertion = "applyPatches applies multiple patches from series file";
    expected = runCommand "patchSeriesWithMultiplePatches-expected" { } ''
      mkdir -p "$out"/{foo,bar}
      cat >"$out/foo/foo" <<'EOF'
      foo content
      EOF
      cat >"$out/bar/bar" <<'EOF'
      bar content
      EOF
    '';
    actual = applyPatches {
      src = runCommand "patchSeriesWithMultiplePatches-src" { } ''
        mkdir -p "$out/foo"
        cat >"$out/init" <<'EOF'
        init content
        EOF
        cat >"$out/foo/init" <<'EOF'
        init content
        EOF
      '';
      patches = [
        (runCommand "patch-series-with-multiple-patches" { } ''
          mkdir -p "$out/subdir"
          cat >"$out/series" <<'EOF'
          0001-add-foo-foo.patch
          ./0002-add-bar-init-bar.patch

          # Comments and empty lines are ignored.
          #
          subdir/0003-remove-init-files.patch
          EOF
          cat >"$out/0001-add-foo-foo.patch" <<'EOF'
          diff --git a/foo/foo b/foo/foo
          new file mode 100644
          index 0000000..257cc56
          --- /dev/null
          +++ b/foo/foo
          @@ -0,0 +1 @@
          +foo content
          EOF
          cat >"$out/0002-add-bar-init-bar.patch" <<'EOF'
          diff --git a/bar/bar b/bar/bar
          new file mode 100644
          index 0000000..5716ca5
          --- /dev/null
          +++ b/bar/bar
          @@ -0,0 +1 @@
          +bar content
          diff --git a/bar/init b/bar/init
          new file mode 100644
          index 0000000..b1b7161
          --- /dev/null
          +++ b/bar/init
          @@ -0,0 +1 @@
          +init content
          EOF
          cat >"$out/subdir/0003-remove-init-files.patch" <<'EOF'
          diff --git a/bar/init b/bar/init
          deleted file mode 100644
          index b1b7161..0000000
          --- a/bar/init
          +++ /dev/null
          @@ -1 +0,0 @@
          -init content
          diff --git a/foo/init b/foo/init
          deleted file mode 100644
          index b1b7161..0000000
          --- a/foo/init
          +++ /dev/null
          @@ -1 +0,0 @@
          -init content
          diff --git a/init b/init
          deleted file mode 100644
          index b1b7161..0000000
          --- a/init
          +++ /dev/null
          @@ -1 +0,0 @@
          -init content
          EOF
        '')
      ];
    };
  };

  patchSeriesWithIncorrectFilePath = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [
      (runCommand "patch-series-with-incorrect-file-path" { } ''
        mkdir -p "$out"
        cat >"$out/series" <<'EOF'
        incorrect-path.patch
        EOF
        cat >"$out/incorrect-path.patch" <<'EOF'
        --- a/nonexistent-file
        +++ b/nonexistent-file
        @@ -1 +1 @@
        -old content
        +new content
        EOF
      '')
    ];
  });

  patchSeriesInvalidExclude = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [
      (runCommand "patch-series-invalid-exclude" { } ''
        mkdir -p "$out"
        touch "$out/0000-excluded.patch"
        touch "$out/-xxx 0000-excluded.patch"
        cat >"$out/series" <<'EOF'
        -xxx 0000-excluded.patch
        EOF
      '')
    ];
  });

  patchSeriesInvalidInclude = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [
      (runCommand "patch-series-invalid-include" { } ''
        mkdir -p "$out"
        touch "$out/0000-included.patch"
        touch "$out/+xxx 0000-included.patch"
        cat >"$out/series" <<'EOF'
        +xxx 0000-included.patch
        EOF
      '')
    ];
  });

  patchSeriesWithMultipleInvalidCharacters = testers.testBuildFailure (applyPatches {
    src = emptyDirectory;
    patches = [
      (writeTextDir "series" ''
        +invalid-patch
        -another-invalid-patch
      '')
    ];
  });

  patchSeriesNotAFile = testers.testEqualContents {
    assertion = "applyPatches ignores non-file patch series";
    expected = emptyDirectory;
    actual = applyPatches {
      src = emptyDirectory;
      patches = [
        (runCommand "patch-series-not-a-file" { } ''
          mkdir -p "$out/series"
        '')
      ];
    };
  };

  directoryWithoutSeriesFile = testers.testEqualContents {
    assertion = "applyPatches applies single patch from a directory without series file";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (writeTextDir "file.patch" ''
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
        '')
      ];
    };
  };

  directoryWithNonPatchFiles = testers.testEqualContents {
    assertion = "applyPatches ignores non-patch files in a directory";
    expected = writeTextDir "file.txt" "original content";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content";
      patches = [
        (writeTextDir "file.txt" ''
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
        '')
      ];
    };
  };

  patchesInSubdirectory = testers.testEqualContents {
    assertion = "applyPatches ignores patches in subdirectories";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (runCommand "patches-in-subdirectory" { } ''
          mkdir -p "$out/subdir"

          cat >"$out/file.patch" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
          EOF

          cat >"$out/subdir/ignored.patch" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +ignored content
          EOF
        '')
      ];
    };
  };

  compressedPatchGzip = testers.testEqualContents {
    assertion = "applyPatches applies gzip compressed patch";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (runCommand "file-patch.gz" { } ''
          gzip >"$out" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
          EOF
        '')
      ];
    };
  };

  compressedPatchBzip2 = testers.testEqualContents {
    assertion = "applyPatches applies bzip2 compressed patch";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (runCommand "file-patch.bz2" { } ''
          bzip2 >"$out" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
          EOF
        '')
      ];
    };
  };

  compressedPatchXz = testers.testEqualContents {
    assertion = "applyPatches applies xz compressed patch";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (runCommand "file-patch.xz" { } ''
          xz >"$out" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
          EOF
        '')
      ];
    };
  };

  compressedPatchLzma = testers.testEqualContents {
    assertion = "applyPatches applies lzma compressed patch";
    expected = writeTextDir "file.txt" "patched content\n";
    actual = applyPatches {
      src = writeTextDir "file.txt" "original content\n";
      patches = [
        (runCommand "file-patch.lzma" { } ''
          lzma >"$out" <<'EOF'
          --- a/file.txt
          +++ b/file.txt
          @@ -1 +1 @@
          -original content
          +patched content
          EOF
        '')
      ];
    };
  };

  malformedCompressedPatch = testers.testBuildFailure (applyPatches {
    src = writeTextDir "file.txt" "original content";
    patches = [
      (runCommand "malformed-patch.gz" { } ''
        cat >"$out" <<'EOF'
        # malformed gzip data
        EOF
      '')
    ];
  });
}

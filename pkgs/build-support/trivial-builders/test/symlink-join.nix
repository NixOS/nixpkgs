{
  symlinkJoin,
  writeTextFile,
  runCommand,
  testers,
}:

let
  inherit (testers) testEqualContents testBuildFailure;

  foo = writeTextFile {
    name = "foo";
    text = "foo";
    destination = "/etc/test.d/foo";
  };

  bar = writeTextFile {
    name = "bar";
    text = "bar";
    destination = "/etc/test.d/bar";
  };

  baz = writeTextFile {
    name = "baz";
    text = "baz";
    destination = "/var/lib/arbitrary/baz";
  };

  qux = writeTextFile {
    name = "qux";
    text = "qux";
  };

  emulatedSymlinkJoinFooBarStrip = runCommand "symlinkJoin-strip-foo-bar" { } ''
    mkdir $out
    ln -s ${foo}/etc/test.d/foo $out/
    ln -s ${bar}/etc/test.d/bar $out/
  '';
in
{
  symlinkJoin = testEqualContents {
    assertion = "symlinkJoin";
    actual = symlinkJoin {
      name = "symlinkJoin";
      paths = [
        foo
        bar
        baz
      ];
    };
    expected = runCommand "symlinkJoin-foo-bar-baz" { } ''
      mkdir -p $out/{var/lib/arbitrary,etc/test.d}
      ln -s {${foo},${bar}}/etc/test.d/* $out/etc/test.d
      ln -s ${baz}/var/lib/arbitrary/baz $out/var/lib/arbitrary/
    '';
  };

  symlinkJoin-strip-paths = testEqualContents {
    assertion = "symlinkJoin-strip-paths";
    actual = symlinkJoin {
      name = "symlinkJoinPrefix";
      paths = [
        foo
        bar
      ];
      stripPrefix = "/etc/test.d";
    };
    expected = emulatedSymlinkJoinFooBarStrip;
  };

  symlinkJoin-strip-paths-skip-missing = testEqualContents {
    assertion = "symlinkJoin-strip-paths-skip-missing";
    actual = symlinkJoin {
      name = "symlinkJoinPrefix";
      paths = [
        foo
        bar
        baz
      ];
      stripPrefix = "/etc/test.d";
    };
    expected = emulatedSymlinkJoinFooBarStrip;
  };

  symlinkJoin-strip-paths-skip-not-directories = testEqualContents {
    assertion = "symlinkJoin-strip-paths-skip-not-directories";
    actual = symlinkJoin {
      name = "symlinkJoinPrefix";
      paths = [
        foo
        bar
        qux
      ];
      stripPrefix = "/etc/test.d";
    };
    expected = emulatedSymlinkJoinFooBarStrip;
  };

  symlinkJoin-fails-on-missing =
    runCommand "symlinkJoin-fails-on-missing"
      {
        failed = testBuildFailure (symlinkJoin {
          name = "symlinkJoin-fail";
          paths = [
            foo
            bar
            baz
          ];
          stripPrefix = "/etc/test.d";
          failOnMissing = true;
        });
      }
      ''
        grep -e "-baz/etc/test.d: No such file or directory" $failed/testBuildFailure.log
        touch $out
      '';

  symlinkJoin-fails-on-file =
    runCommand "symlinkJoin-fails-on-file"
      {
        failed = testBuildFailure (symlinkJoin {
          name = "symlinkJoin-fail";
          paths = [
            foo
            bar
            qux
          ];
          stripPrefix = "/etc/test.d";
          failOnMissing = true;
        });
      }
      ''
        grep -e "-qux/etc/test.d: Not a directory" $failed/testBuildFailure.log
        touch $out
      '';
}

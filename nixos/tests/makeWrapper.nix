import ./make-test-python.nix ({ ... }: {
  name = "makeWrapper";

  machine = { pkgs, ... }: let
    # Testfiles
    foofile = pkgs.writeText "foofile" "foo";
    barfile = pkgs.writeText "barfile" "bar";

    # Wrapped binaries
    wrappedArgv0 = pkgs.writeCBin "wrapped-argv0" ''
      #include <stdio.h>

      void main(int argc, char** argv) {
        printf("argv0=%s", argv[0]);
      }
    '';
    wrappedBinaryVar = pkgs.writeShellScript "wrapped-var" ''
      echo "var=$VAR"
    '';
    wrappedBinaryArgs = pkgs.writeShellScript "wrapped-args" ''
      echo "$@"
    '';

    mkWrapperBinary = { name, args, wrapped ? wrappedBinaryVar }: pkgs.runCommand name {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin
      makeWrapper "${wrapped}" "$out/bin/${name}" ${pkgs.lib.escapeShellArgs args}
    '';
  in {
    environment.systemPackages = [
      (mkWrapperBinary { name = "test-argv0"; args = [ "--argv0" "foo" ]; wrapped = "${wrappedArgv0}/bin/wrapped-argv0"; })
      (mkWrapperBinary { name = "test-set"; args = [ "--set" "VAR" "abc" ]; })
      (mkWrapperBinary { name = "test-set-default"; args = [ "--set-default" "VAR" "abc" ]; })
      (mkWrapperBinary { name = "test-unset"; args = [ "--unset" "VAR" ]; })
      (mkWrapperBinary { name = "test-run"; args = [ "--run" "echo bar" ]; })
      (mkWrapperBinary { name = "test-run-and-set"; args = [ "--run" "export VAR=foo" "--set" "VAR" "bar" ]; })
      (mkWrapperBinary { name = "test-args"; args = [ "--add-flags" "abc" ]; wrapped = wrappedBinaryArgs; })
      (mkWrapperBinary { name = "test-prefix"; args = [ "--prefix" "VAR" ":" "abc" ]; })
      (mkWrapperBinary { name = "test-prefix-spaces"; args = [ "--prefix" "VAR" " : " "abc" ]; })
      (mkWrapperBinary { name = "test-suffix"; args = [ "--suffix" "VAR" ":" "abc" ]; })
      (mkWrapperBinary { name = "test-suffix-spaces"; args = [ "--suffix" "VAR" " : " "abc" ]; })
      (mkWrapperBinary { name = "test-prefix-and-suffix"; args = [ "--prefix" "VAR" ":" "foo" "--suffix" "VAR" ":" "bar" ]; })
      (mkWrapperBinary { name = "test-suffix-each"; args = [ "--suffix-each" "VAR" ":" "foo bar" ]; })
      (mkWrapperBinary { name = "test-suffix-contents"; args = [ "--suffix-contents" "VAR" ":" "${foofile} ${barfile}" ]; })
      (mkWrapperBinary { name = "test-prefix-contents"; args = [ "--prefix-contents" "VAR" ":" "${foofile} ${barfile}" ]; })
    ];
  };

  testScript = /* python */ ''
    def equals(cmd, to_expect):
        machine.succeed(f'[ "$({cmd})" = \'{to_expect}\' ]')

    with subtest('argv0'):
        # --argv0 works
        equals('test-argv0', 'argv0=foo')

    with subtest('set/det-default/unset'):
        # --set works
        equals('test-set', 'var=abc')
        # --set overwrites the variable
        equals('VAR=foo test-set', 'var=abc')
        # --set-default works
        equals('test-set-default', 'var=abc')
        # --set-default doesn't overwrite the variable
        equals('VAR=foo test-set-default', 'var=foo')
        # --unset works
        equals('VAR=foo test-unset', 'var=')

    with subtest('add-flags'):
        # --add-flags works
        equals('test-args', 'abc')
        # given flags are appended
        equals('test-args foo', 'abc foo')

    with subtest('run'):
        # --run works
        equals('test-run', 'bar\nvar=')
        # --run & --set works
        equals('test-run-and-set', 'var=bar')

    with subtest('prefix'):
        # --prefix works
        equals('VAR=foo test-prefix', 'var=abc:foo')
        # sets variable if not set yet
        equals('test-prefix', 'var=abc')
        # adds the same variable multiple times
        equals('VAR=abc test-prefix', 'var=abc:abc')
        # test edge case with spaces in the separator
        equals('VAR=foo test-prefix-spaces', 'var=abc : foo')
        equals('test-prefix-spaces', 'var=abc')
        equals('VAR=abc test-prefix-spaces', 'var=abc : abc')

    with subtest('suffix'):
        # --suffix works
        equals('VAR=foo test-suffix', 'var=foo:abc')
        # sets variable if not set yet
        equals('test-suffix', 'var=abc')
        # adds the same variable multiple times
        equals('VAR=abc test-suffix', 'var=abc:abc')
        # test edge case with spaces in the separator
        equals('VAR=foo test-suffix-spaces', 'var=foo : abc')
        equals('test-suffix-spaces', 'var=abc')
        equals('VAR=abc test-suffix-spaces', 'var=abc : abc')
        # --prefix in combination with --suffix
        equals('VAR=abc test-prefix-and-suffix', 'var=foo:abc:bar')

    with subtest('suffix-each/prefix-contents/suffix-contents'):
        # --suffix-each works
        equals('VAR=abc test-suffix-each', 'var=abc:foo:bar')
        # --suffix-contents works
        equals('VAR=abc test-suffix-contents', 'var=abc:foo:bar')
        # --prefix-contents works
        equals('VAR=abc test-prefix-contents', 'var=bar:foo:abc')
  '';
})

# to run these tests:
# nix-instantiate --eval --strict nixpkgs/lib/tests/misc.nix
# if the resulting list is empty, all tests passed
with import ../default.nix;

let

  testSanitizeDerivationName = { name, expected }:
  let
    drv = derivation {
      name = strings.sanitizeDerivationName name;
      builder = "x";
      system = "x";
    };
  in {
    # Evaluate the derivation so an invalid name would be caught
    expr = builtins.seq drv.drvPath drv.name;
    inherit expected;
  };

in

runTests {


# TRIVIAL

  testId = {
    expr = id 1;
    expected = 1;
  };

  testConst = {
    expr = const 2 3;
    expected = 2;
  };

  testPipe = {
    expr = pipe 2 [
      (x: x + 2) # 2 + 2 = 4
      (x: x * 2) # 4 * 2 = 8
    ];
    expected = 8;
  };

  testPipeEmpty = {
    expr = pipe 2 [];
    expected = 2;
  };

  testPipeStrings = {
    expr = pipe [ 3 4 ] [
      (map toString)
      (map (s: s + "\n"))
      concatStrings
    ];
    expected = ''
      3
      4
    '';
  };

  /*
  testOr = {
    expr = or true false;
    expected = true;
  };
  */

  testAnd = {
    expr = and true false;
    expected = false;
  };

  testFix = {
    expr = fix (x: {a = if x ? a then "a" else "b";});
    expected = {a = "a";};
  };

  testComposeExtensions = {
    expr = let obj = makeExtensible (self: { foo = self.bar; });
               f = self: super: { bar = false; baz = true; };
               g = self: super: { bar = super.baz or false; };
               f_o_g = composeExtensions f g;
               composed = obj.extend f_o_g;
           in composed.foo;
    expected = true;
  };

  testBitAnd = {
    expr = (bitAnd 3 10);
    expected = 2;
  };

  testBitOr = {
    expr = (bitOr 3 10);
    expected = 11;
  };

  testBitXor = {
    expr = (bitXor 3 10);
    expected = 9;
  };

  testToHex = {
    expr = toHex 250;
    expected = "FA";
  };

  testToBase = {
    expr = toBase 2 6;
    expected = [ 1 1 0 ];
  };

# STRINGS

  testConcatMapStrings = {
    expr = concatMapStrings (x: x + ";") ["a" "b" "c"];
    expected = "a;b;c;";
  };

  testConcatStringsSep = {
    expr = concatStringsSep "," ["a" "b" "c"];
    expected = "a,b,c";
  };

  testSplitStringsSimple = {
    expr = strings.splitString "." "a.b.c.d";
    expected = [ "a" "b" "c" "d" ];
  };

  testSplitStringsEmpty = {
    expr = strings.splitString "." "a..b";
    expected = [ "a" "" "b" ];
  };

  testSplitStringsOne = {
    expr = strings.splitString ":" "a.b";
    expected = [ "a.b" ];
  };

  testSplitStringsNone = {
    expr = strings.splitString "." "";
    expected = [ "" ];
  };

  testSplitStringsFirstEmpty = {
    expr = strings.splitString "/" "/a/b/c";
    expected = [ "" "a" "b" "c" ];
  };

  testSplitStringsLastEmpty = {
    expr = strings.splitString ":" "2001:db8:0:0042::8a2e:370:";
    expected = [ "2001" "db8" "0" "0042" "" "8a2e" "370" "" ];
  };

  testSplitVersionSingle = {
    expr = versions.splitVersion "1";
    expected = [ "1" ];
  };

  testSplitVersionDouble = {
    expr = versions.splitVersion "1.2";
    expected = [ "1" "2" ];
  };

  testSplitVersionTriple = {
    expr = versions.splitVersion "1.2.3";
    expected = [ "1" "2" "3" ];
  };

  testIsStorePath =  {
    expr =
      let goodPath =
            "${builtins.storeDir}/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11";
      in {
        storePath = isStorePath goodPath;
        storePathDerivation = isStorePath (import ../.. { system = "x86_64-linux"; }).hello;
        storePathAppendix = isStorePath
          "${goodPath}/bin/python";
        nonAbsolute = isStorePath (concatStrings (tail (stringToCharacters goodPath)));
        asPath = isStorePath (/. + goodPath);
        otherPath = isStorePath "/something/else";
        otherVals = {
          attrset = isStorePath {};
          list = isStorePath [];
          int = isStorePath 42;
        };
      };
    expected = {
      storePath = true;
      storePathDerivation = true;
      storePathAppendix = false;
      nonAbsolute = false;
      asPath = true;
      otherPath = false;
      otherVals = {
        attrset = false;
        list = false;
        int = false;
      };
    };
  };

# LISTS

  testFilter = {
    expr = filter (x: x != "a") ["a" "b" "c" "a"];
    expected = ["b" "c"];
  };

  testFold =
    let
      f = op: fold: fold op 0 (range 0 100);
      # fold with associative operator
      assoc = f builtins.add;
      # fold with non-associative operator
      nonAssoc = f builtins.sub;
    in {
      expr = {
        assocRight = assoc foldr;
        # right fold with assoc operator is same as left fold
        assocRightIsLeft = assoc foldr == assoc foldl;
        nonAssocRight = nonAssoc foldr;
        nonAssocLeft = nonAssoc foldl;
        # with non-assoc operator the fold results are not the same
        nonAssocRightIsNotLeft = nonAssoc foldl != nonAssoc foldr;
        # fold is an alias for foldr
        foldIsRight = nonAssoc fold == nonAssoc foldr;
      };
      expected = {
        assocRight = 5050;
        assocRightIsLeft = true;
        nonAssocRight = 50;
        nonAssocLeft = (-5050);
        nonAssocRightIsNotLeft = true;
        foldIsRight = true;
      };
    };

  testTake = testAllTrue [
    ([] == (take 0 [  1 2 3 ]))
    ([1] == (take 1 [  1 2 3 ]))
    ([ 1 2 ] == (take 2 [  1 2 3 ]))
    ([ 1 2 3 ] == (take 3 [  1 2 3 ]))
    ([ 1 2 3 ] == (take 4 [  1 2 3 ]))
  ];

  testFoldAttrs = {
    expr = foldAttrs (n: a: [n] ++ a) [] [
    { a = 2; b = 7; }
    { a = 3;        c = 8; }
    ];
    expected = { a = [ 2 3 ]; b = [7]; c = [8];};
  };

  testSort = {
    expr = sort builtins.lessThan [ 40 2 30 42 ];
    expected = [2 30 40 42];
  };

  testToIntShouldConvertStringToInt = {
    expr = toInt "27";
    expected = 27;
  };

  testToIntShouldThrowErrorIfItCouldNotConvertToInt = {
    expr = builtins.tryEval (toInt "\"foo\"");
    expected = { success = false; value = false; };
  };

  testHasAttrByPathTrue = {
    expr = hasAttrByPath ["a" "b"] { a = { b = "yey"; }; };
    expected = true;
  };

  testHasAttrByPathFalse = {
    expr = hasAttrByPath ["a" "b"] { a = { c = "yey"; }; };
    expected = false;
  };


# ATTRSETS

  # code from the example
  testRecursiveUpdateUntil = {
    expr = recursiveUpdateUntil (path: l: r: path == ["foo"]) {
      # first attribute set
      foo.bar = 1;
      foo.baz = 2;
      bar = 3;
    } {
      #second attribute set
      foo.bar = 1;
      foo.quz = 2;
      baz = 4;
    };
    expected = {
      foo.bar = 1; # 'foo.*' from the second set
      foo.quz = 2; #
      bar = 3;     # 'bar' from the first set
      baz = 4;     # 'baz' from the second set
    };
  };

  testOverrideExistingEmpty = {
    expr = overrideExisting {} { a = 1; };
    expected = {};
  };

  testOverrideExistingDisjoint = {
    expr = overrideExisting { b = 2; } { a = 1; };
    expected = { b = 2; };
  };

  testOverrideExistingOverride = {
    expr = overrideExisting { a = 3; b = 2; } { a = 1; };
    expected = { a = 1; b = 2; };
  };

# GENERATORS
# these tests assume attributes are converted to lists
# in alphabetical order

  testMkKeyValueDefault = {
    expr = generators.mkKeyValueDefault {} ":" "f:oo" "bar";
    expected = ''f\:oo:bar'';
  };

  testMkValueString = {
    expr = let
      vals = {
        int = 42;
        string = ''fo"o'';
        bool = true;
        bool2 = false;
        null = null;
        # float = 42.23; # floats are strange
      };
      in mapAttrs
        (const (generators.mkValueStringDefault {}))
        vals;
    expected = {
      int = "42";
      string = ''fo"o'';
      bool = "true";
      bool2 = "false";
      null = "null";
      # float = "42.23" true false [ "bar" ] ]'';
    };
  };

  testToKeyValue = {
    expr = generators.toKeyValue {} {
      key = "value";
      "other=key" = "baz";
    };
    expected = ''
      key=value
      other\=key=baz
    '';
  };

  testToINIEmpty = {
    expr = generators.toINI {} {};
    expected = "";
  };

  testToINIEmptySection = {
    expr = generators.toINI {} { foo = {}; bar = {}; };
    expected = ''
      [bar]

      [foo]
    '';
  };

  testToINIDuplicateKeys = {
    expr = generators.toINI { listsAsDuplicateKeys = true; } { foo.bar = true; baz.qux = [ 1 false ]; };
    expected = ''
      [baz]
      qux=1
      qux=false

      [foo]
      bar=true
    '';
  };

  testToINIDefaultEscapes = {
    expr = generators.toINI {} {
      "no [ and ] allowed unescaped" = {
        "and also no = in keys" = 42;
      };
    };
    expected = ''
      [no \[ and \] allowed unescaped]
      and also no \= in keys=42
    '';
  };

  testToINIDefaultFull = {
    expr = generators.toINI {} {
      "section 1" = {
        attribute1 = 5;
        x = "Me-se JarJar Binx";
        # booleans are converted verbatim by default
        boolean = false;
      };
      "foo[]" = {
        "he\\h=he" = "this is okay";
      };
    };
    expected = ''
      [foo\[\]]
      he\h\=he=this is okay

      [section 1]
      attribute1=5
      boolean=false
      x=Me-se JarJar Binx
    '';
  };

  /* right now only invocation check */
  testToJSONSimple =
    let val = {
      foobar = [ "baz" 1 2 3 ];
    };
    in {
      expr = generators.toJSON {} val;
      # trivial implementation
      expected = builtins.toJSON val;
  };

  /* right now only invocation check */
  testToYAMLSimple =
    let val = {
      list = [ { one = 1; } { two = 2; } ];
      all = 42;
    };
    in {
      expr = generators.toYAML {} val;
      # trivial implementation
      expected = builtins.toJSON val;
  };

  testToPretty = {
    expr = mapAttrs (const (generators.toPretty {})) rec {
      int = 42;
      float = 0.1337;
      bool = true;
      string = ''fno"rd'';
      path = /. + "/foo";
      null_ = null;
      function = x: x;
      functionArgs = { arg ? 4, foo }: arg;
      list = [ 3 4 function [ false ] ];
      attrs = { foo = null; "foo bar" = "baz"; };
      drv = derivation { name = "test"; system = builtins.currentSystem; };
    };
    expected = rec {
      int = "42";
      float = "~0.133700";
      bool = "true";
      string = ''"fno\"rd"'';
      path = "/foo";
      null_ = "null";
      function = "<λ>";
      functionArgs = "<λ:{(arg),foo}>";
      list = "[ 3 4 ${function} [ false ] ]";
      attrs = "{ \"foo\" = null; \"foo bar\" = \"baz\"; }";
      drv = "<δ:test>";
    };
  };

  testToPrettyAllowPrettyValues = {
    expr = generators.toPretty { allowPrettyValues = true; }
             { __pretty = v: "«" + v + "»"; val = "foo"; };
    expected  = "«foo»";
  };


# CLI

  testToGNUCommandLine = {
    expr = cli.toGNUCommandLine {} {
      data = builtins.toJSON { id = 0; };
      X = "PUT";
      retry = 3;
      retry-delay = null;
      url = [ "https://example.com/foo" "https://example.com/bar" ];
      silent = false;
      verbose = true;
    };

    expected = [
      "-X" "PUT"
      "--data" "{\"id\":0}"
      "--retry" "3"
      "--url" "https://example.com/foo"
      "--url" "https://example.com/bar"
      "--verbose"
    ];
  };

  testToGNUCommandLineShell = {
    expr = cli.toGNUCommandLineShell {} {
      data = builtins.toJSON { id = 0; };
      X = "PUT";
      retry = 3;
      retry-delay = null;
      url = [ "https://example.com/foo" "https://example.com/bar" ];
      silent = false;
      verbose = true;
    };

    expected = "'-X' 'PUT' '--data' '{\"id\":0}' '--retry' '3' '--url' 'https://example.com/foo' '--url' 'https://example.com/bar' '--verbose'";
  };

  testSanitizeDerivationNameLeadingDots = testSanitizeDerivationName {
    name = "..foo";
    expected = "foo";
  };

  testSanitizeDerivationNameAscii = testSanitizeDerivationName {
    name = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    expected = "-+--.-0123456789-=-?-ABCDEFGHIJKLMNOPQRSTUVWXYZ-_-abcdefghijklmnopqrstuvwxyz-";
  };

  testSanitizeDerivationNameTooLong = testSanitizeDerivationName {
    name = "This string is loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong";
    expected = "loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong";
  };

  testSanitizeDerivationNameTooLongWithInvalid = testSanitizeDerivationName {
    name = "Hello there aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa &&&&&&&&";
    expected = "there-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-";
  };

  testSanitizeDerivationNameEmpty = testSanitizeDerivationName {
    name = "";
    expected = "unknown";
  };
}

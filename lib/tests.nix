let inherit (builtins) add; in
with import ./default.nix;

runTests {

  testId = {
    expr = id 1;
    expected = 1;
  };

  testConst = {
    expr = const 2 3;
    expected = 2;
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

  testConcatMapStrings = {
    expr = concatMapStrings (x: x + ";") ["a" "b" "c"];
    expected = "a;b;c;";
  };

  testConcatStringsSep = {
    expr = concatStringsSep "," ["a" "b" "c"];
    expected = "a,b,c";
  };

  testFilter = {
    expr = filter (x: x != "a") ["a" "b" "c" "a"];
    expected = ["b" "c"];
  };

  testFold = {
    expr = fold (builtins.add) 0 (range 0 100);
    expected = 5050;
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

  testOverridableDelayableArgsTest = {
    expr =
      let res1 = defaultOverridableDelayableArgs id {};
          res2 = defaultOverridableDelayableArgs id { a = 7; };
          res3 = let x = defaultOverridableDelayableArgs id { a = 7; };
                 in (x.merge) { b = 10; };
          res4 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { b = 10; });
          res5 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { a = add x.a 3; });
          res6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                     y = x.merge {};
                in (y.merge) { a = 10; };

          resRem7 = res6.replace (a: removeAttrs a ["a"]);

          resReplace6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                            x2 = x.merge { a = 20; }; # now we have 27
                        in (x2.replace) { a = 10; }; # and override the value by 10

          # fixed tests (delayed args): (when using them add some comments, please)
          resFixed1 =
                let x = defaultOverridableDelayableArgs id ( x: { a = 7; c = x.fixed.b; });
                    y = x.merge (x: { name = "name-${builtins.toString x.fixed.c}"; });
                in (y.merge) { b = 10; };
          strip = attrs: removeAttrs attrs ["merge" "replace"];
      in all id
        [ ((strip res1) == { })
          ((strip res2) == { a = 7; })
          ((strip res3) == { a = 7; b = 10; })
          ((strip res4) == { a = 7; b = 10; })
          ((strip res5) == { a = 10; })
          ((strip res6) == { a = 17; })
          ((strip resRem7) == {})
          ((strip resFixed1) == { a = 7; b = 10; c =10; name = "name-10"; })
        ];
    expected = true;
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


  /* Generator tests */
  # these tests assume attributes are converted to lists
  # in alphabetical order

  testMkKeyValueDefault = {
    expr = generators.mkKeyValueDefault ":" "f:oo" "bar";
    expected = ''f\:oo:bar'';
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
      # trival implementation
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
      # trival implementation
      expected = builtins.toJSON val;
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

}

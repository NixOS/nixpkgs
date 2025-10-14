# Run with:
#   cd nixpkgs
#   nix-instantiate --eval --strict lib/tests/linked-lists.nix
#
# If the resulting list is empty, all tests passed.
# Alternatively, to run all `lib` tests:
#   nix-build lib/tests/release.nix

let
  lib = import ../default.nix;
  inherit (lib) linkedLists;

  # Test helper to compare actual vs expected
  testCase =
    name: expected: actual:
    if actual == expected then [ ] else [ { inherit name expected actual; } ];

  # Helper to create a linked list manually for testing
  mkList =
    elems:
    if elems == [ ] then
      null
    else
      {
        head = builtins.head elems;
        tail = mkList (builtins.tail elems);
      };

in

lib.runTests {
  # fromList tests
  testFromListEmpty = {
    expr = linkedLists.fromList [ ];
    expected = null;
  };

  testFromListSingle = {
    expr = linkedLists.fromList [ 1 ];
    expected = {
      head = 1;
      tail = null;
    };
  };

  testFromListMultiple = {
    expr = linkedLists.fromList [
      1
      2
      3
    ];
    expected = {
      head = 1;
      tail = {
        head = 2;
        tail = {
          head = 3;
          tail = null;
        };
      };
    };
  };

  testFromListStrings = {
    expr = linkedLists.fromList [
      "a"
      "b"
      "c"
    ];
    expected = {
      head = "a";
      tail = {
        head = "b";
        tail = {
          head = "c";
          tail = null;
        };
      };
    };
  };

  # toList tests
  testToListEmpty = {
    expr = linkedLists.toList null;
    expected = [ ];
  };

  testToListSingle = {
    expr = linkedLists.toList {
      head = 1;
      tail = null;
    };
    expected = [ 1 ];
  };

  testToListMultiple = {
    expr = linkedLists.toList {
      head = 1;
      tail = {
        head = 2;
        tail = {
          head = 3;
          tail = null;
        };
      };
    };
    expected = [
      1
      2
      3
    ];
  };

  testToListStrings = {
    expr = linkedLists.toList {
      head = "a";
      tail = {
        head = "b";
        tail = {
          head = "c";
          tail = null;
        };
      };
    };
    expected = [
      "a"
      "b"
      "c"
    ];
  };

  # Round-trip tests
  testRoundTripEmpty = {
    expr = linkedLists.toList (linkedLists.fromList [ ]);
    expected = [ ];
  };

  testRoundTripSingle = {
    expr = linkedLists.toList (linkedLists.fromList [ 42 ]);
    expected = [ 42 ];
  };

  testRoundTripMultiple = {
    expr = linkedLists.toList (
      linkedLists.fromList [
        1
        2
        3
        4
        5
      ]
    );
    expected = [
      1
      2
      3
      4
      5
    ];
  };

  testRoundTripReverse = {
    expr = linkedLists.fromList (
      linkedLists.toList {
        head = "x";
        tail = {
          head = "y";
          tail = null;
        };
      }
    );
    expected = {
      head = "x";
      tail = {
        head = "y";
        tail = null;
      };
    };
  };

  # tieredBinaryReduce tests
  testTieredBinaryReduceEmpty = {
    expr = linkedLists.tieredBinaryReduce 0 (a: b: a + b) null;
    expected = 0;
  };

  testTieredBinaryReduceSum = {
    expr = linkedLists.tieredBinaryReduce 0 (a: b: a + b) (
      linkedLists.fromList [
        1
        2
        3
        4
      ]
    );
    expected = 10;
  };

  testTieredBinaryReduceProduct = {
    expr = linkedLists.tieredBinaryReduce 1 (a: b: a * b) (
      linkedLists.fromList [
        2
        3
        4
      ]
    );
    expected = 24;
  };

  testTieredBinaryReduceLarge = {
    expr = linkedLists.tieredBinaryReduce 0 (a: b: a + b) (
      linkedLists.fromList (lib.genList (x: x) 20000)
    );
    # Triangle sum formula: sum of 0 to n-1 = (n-1) * n / 2
    expected =
      let
        n = 20000;
      in
      (n - 1) * n / 2;
  };

  # map tests
  testMapEmpty = {
    expr = linkedLists.toList (linkedLists.map (x: x * 2) null);
    expected = [ ];
  };

  testMapSingle = {
    expr = linkedLists.toList (linkedLists.map (x: x * 2) (linkedLists.fromList [ 5 ]));
    expected = [ 10 ];
  };

  testMapMultiple = {
    expr = linkedLists.toList (
      linkedLists.map (x: x * 2) (
        linkedLists.fromList [
          1
          2
          3
          4
        ]
      )
    );
    expected = [
      2
      4
      6
      8
    ];
  };

  testMapStrings = {
    expr = linkedLists.toList (
      linkedLists.map (s: s + "!") (
        linkedLists.fromList [
          "a"
          "b"
          "c"
        ]
      )
    );
    expected = [
      "a!"
      "b!"
      "c!"
    ];
  };

  testMapLarge = {
    expr = linkedLists.length (
      linkedLists.map (x: x * 2) (linkedLists.fromList (lib.genList (x: x) 20000))
    );
    expected = 20000;
  };

  testMapLargePrefix = {
    expr = linkedLists.toList (
      linkedLists.take 5 (linkedLists.map (x: x * 2) (linkedLists.fromList (lib.genList (x: x) 20000)))
    );
    expected = [
      0
      2
      4
      6
      8
    ];
  };

  # length tests
  testLengthEmpty = {
    expr = linkedLists.length null;
    expected = 0;
  };

  testLengthSingle = {
    expr = linkedLists.length (linkedLists.fromList [ 1 ]);
    expected = 1;
  };

  testLengthMultiple = {
    expr = linkedLists.length (
      linkedLists.fromList [
        1
        2
        3
        4
        5
      ]
    );
    expected = 5;
  };

  testLengthLarge = {
    expr = linkedLists.length (linkedLists.fromList (lib.genList (x: x) 20000));
    expected = 20000;
  };

  # drop tests
  testDropZero = {
    expr = linkedLists.toList (
      linkedLists.drop 0 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [
      1
      2
      3
    ];
  };

  testDropPartial = {
    expr = linkedLists.toList (
      linkedLists.drop 2 (
        linkedLists.fromList [
          1
          2
          3
          4
          5
        ]
      )
    );
    expected = [
      3
      4
      5
    ];
  };

  testDropAll = {
    expr = linkedLists.toList (
      linkedLists.drop 3 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [ ];
  };

  testDropMoreThanAvailable = {
    expr = linkedLists.toList (
      linkedLists.drop 10 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [ ];
  };

  testDropFromEmpty = {
    expr = linkedLists.toList (linkedLists.drop 5 null);
    expected = [ ];
  };

  testDropLarge = {
    expr = linkedLists.toList (
      linkedLists.drop 15000 (linkedLists.fromList (lib.genList (x: x) 20000))
    );
    expected = lib.genList (x: x + 15000) 5000;
  };

  testDropLargePrefix = {
    expr = linkedLists.toList (
      linkedLists.take 5 (linkedLists.drop 15000 (linkedLists.fromList (lib.genList (x: x) 20000)))
    );
    expected = [
      15000
      15001
      15002
      15003
      15004
    ];
  };

  # take tests
  testTakeZero = {
    expr = linkedLists.toList (
      linkedLists.take 0 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [ ];
  };

  testTakePartial = {
    expr = linkedLists.toList (
      linkedLists.take 2 (
        linkedLists.fromList [
          1
          2
          3
          4
          5
        ]
      )
    );
    expected = [
      1
      2
    ];
  };

  testTakeAll = {
    expr = linkedLists.toList (
      linkedLists.take 3 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [
      1
      2
      3
    ];
  };

  testTakeMoreThanAvailable = {
    expr = linkedLists.toList (
      linkedLists.take 10 (
        linkedLists.fromList [
          1
          2
          3
        ]
      )
    );
    expected = [
      1
      2
      3
    ];
  };

  # Large list tests - testing beyond default max-call-depth
  # First test just the prefix to verify fromList is working correctly
  testFromListLargePrefix = {
    expr = linkedLists.toList (linkedLists.take 5 (linkedLists.fromList (lib.genList (x: x) 20000)));
    expected = [
      0
      1
      2
      3
      4
    ];
  };

  testFromListLarge = {
    expr = builtins.length (linkedLists.toList (linkedLists.fromList (lib.genList (x: x) 20000)));
    expected = 20000;
  };

  testToListLarge = {
    expr = builtins.length (linkedLists.toList (linkedLists.fromList (lib.genList (x: x) 20000)));
    expected = 20000;
  };

  testRoundTripLarge = {
    expr =
      let
        original = lib.genList (x: x) 20000;
        result = linkedLists.toList (linkedLists.fromList original);
      in
      result == original;
    expected = true;
  };

  # Test that first and last elements are preserved in large lists
  testLargeListFirstLast = {
    expr =
      let
        original = lib.genList (x: x) 20000;
        linked = linkedLists.fromList original;
        result = linkedLists.toList linked;
      in
      {
        first = builtins.head result;
        last = builtins.elemAt result 19999;
      };
    expected = {
      first = 0;
      last = 19999;
    };
  };

  # Tests with very large lists to ensure O(log n) stack depth
  # These would fail with linear reduceChunk/countChunk implementations
  testTieredBinaryReduceVeryLarge = {
    expr = linkedLists.tieredBinaryReduce 0 (a: b: a + b) (
      linkedLists.fromList (lib.genList (x: x) 100000)
    );
    # Triangle sum formula: sum of 0 to n-1 = (n-1) * n / 2
    expected =
      let
        n = 100000;
      in
      (n - 1) * n / 2;
  };

  testLengthVeryLarge = {
    expr = linkedLists.length (linkedLists.fromList (lib.genList (x: x) 100000));
    expected = 100000;
  };

  testToListVeryLarge = {
    expr = builtins.length (linkedLists.toList (linkedLists.fromList (lib.genList (x: x) 100000)));
    expected = 100000;
  };
}

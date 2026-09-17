let
  lib = import ../default.nix;
in
lib.runTests {
  testFromRONBooleanFalse = {
    expr = lib.ron.fromRON "false";
    expected = false;
  };

  testFromRONBooleanTrue = {
    expr = lib.ron.fromRON "true";
    expected = true;
  };

  testFromRONChar = {
    expr = lib.ron.fromRON "'c'";
    expected = lib.ron.mkChar "c";
  };

  testFromRONComplex = {
    expr = lib.ron.fromRON ''
      (
        name: "John Doe",
        age: 42,
        is_student: false,
        courses: [
          (
            name: "History",
            credits: 3,
          ),
          (
            name: "Math",
            credits: 4,
          ),
        ],
        address: Some((
          street: "123 Main St",
          city: "Anytown",
        )),
      )
    '';
    expected = {
      name = "John Doe";
      age = 42;
      is_student = false;
      courses = [
        {
          name = "History";
          credits = 3;
        }
        {
          name = "Math";
          credits = 4;
        }
      ];
      address = lib.ron.mkOptional {
        street = "123 Main St";
        city = "Anytown";
      };
    };
  };

  testFromRONEmptyList = {
    expr = lib.ron.fromRON "[]";
    expected = [ ];
  };

  testFromRONEnum = {
    expr = lib.ron.fromRON "MyEnum(1, 2)";
    expected = lib.ron.mkEnum {
      variant = "MyEnum";
      values = [
        1
        2
      ];
    };
  };

  testFromRONFloat = {
    expr = lib.ron.fromRON "1.23";
    expected = 1.23;
  };

  testFromRONFloatWithManyDecimals = {
    expr = lib.ron.fromRON "3.1415926535";
    expected = lib.ron.mkRaw "3.1415926535";
  };

  testFromRONInteger = {
    expr = lib.ron.fromRON "123";
    expected = 123;
  };

  testFromRONList = {
    expr = lib.ron.fromRON "[1, 2, 3]";
    expected = [
      1
      2
      3
    ];
  };

  testFromRONListWithMixedTypes = {
    expr = lib.ron.fromRON ''[1, "hello", true]'';
    expected = [
      1
      "hello"
      true
    ];
  };

  testFromRONMap = {
    expr = lib.ron.fromRON ''{ "a": 1, "b": 2 }'';
    expected = lib.ron.mkMap [
      {
        key = "a";
        value = 1;
      }
      {
        key = "b";
        value = 2;
      }
    ];
  };

  testFromRONNamedStruct = {
    expr = lib.ron.fromRON "MyStruct(a: 1, b: 2)";
    expected = lib.ron.mkNamedStruct {
      name = "MyStruct";
      value = {
        a = 1;
        b = 2;
      };
    };
  };

  testFromRONNegativeInteger = {
    expr = lib.ron.fromRON "-456";
    expected = -456;
  };

  testFromRONNestedStruct = {
    expr = lib.ron.fromRON "(a: 1, b: (c: 2))";
    expected = {
      a = 1;
      b = {
        c = 2;
      };
    };
  };

  testFromRONOptionalNone = {
    expr = lib.ron.fromRON "None";
    expected = lib.ron.mkOptional null;
  };

  testFromRONOptionalSome = {
    expr = lib.ron.fromRON "Some(42)";
    expected = lib.ron.mkOptional 42;
  };

  testFromRONString = {
    expr = lib.ron.fromRON ''"hello world"'';
    expected = "hello world";
  };

  testFromRONStruct = {
    expr = lib.ron.fromRON "(a: 1, b: true)";
    expected = {
      a = 1;
      b = true;
    };
  };

  testFromRONtoRON =
    let
      value = {
        name = "Roundtrip";
        data = [
          1
          { a = "b"; }
          [ false ]
        ];
        nested = {
          optional = lib.ron.mkOptional null;
        };
      };
    in
    {
      expr = lib.ron.fromRON (lib.ron.toRON { } value);
      expected = value;
    };

  testFromRONTuple = {
    expr = lib.ron.fromRON ''(1, "hello", false)'';
    expected = lib.ron.mkTuple [
      1
      "hello"
      false
    ];
  };

  testToRONBoolean = {
    expr = lib.ron.toRON { } true;
    expected = "true";
  };

  testToRONChar = {
    expr = lib.ron.toRON { } (lib.ron.mkChar "c");
    expected = "'c'";
  };

  testToRONComplex = {
    expr = lib.ron.toRON { } {
      name = "Jane Doe";
      age = 38;
      is_student = true;
      courses = [
        {
          name = "Art";
          credits = 3;
        }
        {
          name = "Science";
          credits = 4;
        }
      ];
      address = lib.ron.mkOptional {
        street = "456 Oak St";
        city = "Otherville";
      };
    };
    expected = ''
      (
          address: Some((
              city: "Otherville",
              street: "456 Oak St",
          )),
          age: 38,
          courses: [
              (
                  credits: 3,
                  name: "Art",
              ),
              (
                  credits: 4,
                  name: "Science",
              ),
          ],
          is_student: true,
          name: "Jane Doe",
      )'';
  };

  testToRONEnum = {
    expr = lib.ron.toRON { } (
      lib.ron.mkEnum {
        variant = "MyEnum";
        values = [
          1
          2
        ];
      }
    );
    expected = ''
      MyEnum(
          1,
          2,
      )'';
  };

  testToRONFloat = {
    expr = lib.ron.toRON { } 3.14;
    expected = "3.14";
  };

  testToRONInteger = {
    expr = lib.ron.toRON { } 123;
    expected = "123";
  };

  testToRONList = {
    expr = lib.ron.toRON { } [
      1
      2
      3
    ];
    expected = ''
      [
          1,
          2,
          3,
      ]'';
  };

  testToRONMap = {
    expr = lib.ron.toRON { } (
      lib.ron.mkMap [
        {
          key = "a";
          value = 1;
        }
      ]
    );
    expected = ''
      {
          "a": 1,
      }'';
  };

  testToRONNamedStruct = {
    expr = lib.ron.toRON { } (
      lib.ron.mkNamedStruct {
        name = "MyStruct";
        value = {
          a = 1;
        };
      }
    );
    expected = ''
      MyStruct(
          a: 1,
      )'';
  };

  testToRONOptionalNone = {
    expr = lib.ron.toRON { } (lib.ron.mkOptional null);
    expected = "None";
  };

  testToRONOptionalSome = {
    expr = lib.ron.toRON { } (lib.ron.mkOptional 42);
    expected = "Some(42)";
  };

  testToRONRaw = {
    expr = lib.ron.toRON { } (lib.ron.mkRaw "raw_value");
    expected = "raw_value";
  };

  testToRONString = {
    expr = lib.ron.toRON { } "hello world";
    expected = ''"hello world"'';
  };

  testToRONStruct = {
    expr = lib.ron.toRON { } {
      a = 1;
      b = true;
    };
    expected = ''
      (
          a: 1,
          b: true,
      )'';
  };

  testToRONTuple = {
    expr = lib.ron.toRON { } (
      lib.ron.mkTuple [
        1
        "a"
        true
      ]
    );
    expected = ''
      (
          1,
          "a",
          true,
      )'';
  };
}

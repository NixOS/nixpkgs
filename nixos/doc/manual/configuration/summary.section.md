# Syntax Summary {#sec-nix-syntax-summary}

Below is a summary of the most important syntactic constructs in the Nix
expression language. It's not complete. In particular, there are many
other built-in functions. See the [Nix
manual](https://nixos.org/nix/manual/#chap-writing-nix-expressions) for
the rest.

| Example                                       | Description                                                                                                        |
|-----------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| *Basic values*                                |                                                                                                                    |
| `"Hello world"`                               | A string                                                                                                           |
| `"${pkgs.bash}/bin/sh"`                       | A string containing an expression (expands to `"/nix/store/hash-bash-version/bin/sh"`)                             |
| `true`, `false`                               | Booleans                                                                                                           |
| `123`                                         | An integer                                                                                                         |
| `./foo.png`                                   | A path (relative to the containing Nix expression)                                                                 |
| *Compound values*                             |                                                                                                                    |
| `{ x = 1; y = 2; }`                           | A set with attributes named `x` and `y`                                                                            |
| `{ foo.bar = 1; }`                            | A nested set, equivalent to `{ foo = { bar = 1; }; }`                                                              |
| `rec { x = "foo"; y = x + "bar"; }`           | A recursive set, equivalent to `{ x = "foo"; y = "foobar"; }`                                                      |
| `[ "foo" "bar" ]`                             | A list with two elements                                                                                           |
| *Operators*                                   |                                                                                                                    |
| `"foo" + "bar"`                               | String concatenation                                                                                               |
| `1 + 2`                                       | Integer addition                                                                                                   |
| `"foo" == "f" + "oo"`                         | Equality test (evaluates to `true`)                                                                                |
| `"foo" != "bar"`                              | Inequality test (evaluates to `true`)                                                                              |
| `!true`                                       | Boolean negation                                                                                                   |
| `{ x = 1; y = 2; }.x`                         | Attribute selection (evaluates to `1`)                                                                             |
| `{ x = 1; y = 2; }.z or 3`                    | Attribute selection with default (evaluates to `3`)                                                                |
| `{ x = 1; y = 2; } // { z = 3; }`             | Merge two sets (attributes in the right-hand set taking precedence)                                                |
| *Control structures*                          |                                                                                                                    |
| `if 1 + 1 == 2 then "yes!" else "no!"`        | Conditional expression                                                                                             |
| `assert 1 + 1 == 2; "yes!"`                   | Assertion check (evaluates to `"yes!"`). See [](#sec-assertions) for using assertions in modules                   |
| `let x = "foo"; y = "bar"; in x + y`          | Variable definition                                                                                                |
| `with pkgs.lib; head [ 1 2 3 ]`               | Add all attributes from the given set to the scope (evaluates to `1`)                                              |
| *Functions (lambdas)*                         |                                                                                                                    |
| `x: x + 1`                                    | A function that expects an integer and returns it increased by 1                                                   |
| `(x: x + 1) 100`                              | A function call (evaluates to 101)                                                                                 |
| `let inc = x: x + 1; in inc (inc (inc 100))`  | A function bound to a variable and subsequently called by name (evaluates to 103)                                  |
| `{ x, y }: x + y`                             | A function that expects a set with required attributes `x` and `y` and concatenates them                           |
| `{ x, y ? "bar" }: x + y`                     | A function that expects a set with required attribute `x` and optional `y`, using `"bar"` as default value for `y` |
| `{ x, y, ... }: x + y`                        | A function that expects a set with required attributes `x` and `y` and ignores any other attributes                |
| `{ x, y } @ args: x + y`                      | A function that expects a set with required attributes `x` and `y`, and binds the whole set to `args`              |
| *Built-in functions*                          |                                                                                                                    |
| `import ./foo.nix`                            | Load and return Nix expression in given file                                                                       |
| `map (x: x + x) [ 1 2 3 ]`                    | Apply a function to every element of a list (evaluates to `[ 2 4 6 ]`)                                             |

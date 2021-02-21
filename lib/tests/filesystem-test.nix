let
  lib = import ../.;
  inherit (lib) filesystem concatMap;
  inherit (filesystem)
    pathHasPrefix
    pathIntersects
    absolutePathComponentsBetween
    commonPath
    ;
  inherit (import ./property-test.nix) forceChecks withItems throws;

  somePaths = [
    /.
    /foo
    /bar
    "/bar"
    /foo/foo
    /foo/bar
    /bar/foo/bar
    /foo/bar/foo
  ];

  alternatePathHasPrefix = prefixPath: otherPath:
    let
      normalizedPathString = pathLike: toString (/. + pathLike);
      pre = normalizedPathString prefixPath;
      other = normalizedPathString otherPath;
    in
      if other == pre
      then true
      else if other == "/"
      then false
      else alternatePathHasPrefix pre (dirOf other);

in

################
# pathHasPrefix

# basics
assert pathHasPrefix /foo /foo;
assert pathHasPrefix /foo /foo/bar;
assert !pathHasPrefix /foo /bar;
assert pathHasPrefix /foo/a /foo/a;
assert pathHasPrefix /foo/a /foo/a/b;
assert !pathHasPrefix /foo/a/b /foo/a;
assert pathHasPrefix /. /foo;
assert !pathHasPrefix /foo /.;

# strings are normalized
assert pathHasPrefix "/foo" "/foo/bar";
assert pathHasPrefix "/foo" "/foo////bar";
assert pathHasPrefix "/foo" "/foo/bar/";
# This fits Nix's disregard for trailing slashes. Not great, but doing the opposite isn't great either.
assert pathHasPrefix "/foo/" "/foo";
assert pathHasPrefix "/foo" "/foo/";

assert !pathHasPrefix /foo /.;
assert !pathHasPrefix /foo /bar/foo;
assert !pathHasPrefix /foo /foof; # not a simple string comparison


assert forceChecks (
  withItems "prefix" somePaths (prefix:
    withItems "other" somePaths (other:
      assert pathHasPrefix prefix other == alternatePathHasPrefix prefix other; {}
    )
  )
);


########################
# absolutePathComponentsBetween

assert absolutePathComponentsBetween /a /a/b/c == ["b" "c"];
assert absolutePathComponentsBetween /a/b /a/b/c == ["c"];
assert absolutePathComponentsBetween /a/b/c /a/b/c == [];
assert throws (absolutePathComponentsBetween /a /.);
assert throws (absolutePathComponentsBetween /a /b);


################
# commonPath

assert commonPath /a /a == /a;
assert commonPath /a "/a" == /a;
assert commonPath "/a" /a == /a;

assert commonPath /a /a/b == /a;
assert commonPath /a/b /a == /a;

assert commonPath /a /a/b == /a;
assert commonPath /a/b /a/c == /a;
assert commonPath /a/b /a/c/d == /a;
assert commonPath /a/b/c /a/b/d == /a/b;
assert commonPath /a/b/c /a/b/c == /a/b/c;
assert commonPath /a/b /. == /.;
assert commonPath /. /. == /.;

{}


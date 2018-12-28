{ lib }:
/* Operations on or within declarative wrappers.


A declarative wrapper defines how a wrapper should look. Its an attribute set
and its attributes represent the arguments passed on to `makeWrapper`.

- `source`          : Wrap program located at `source` to new location. When specified, use `makeWrapper`, otherwise, `wrapProgram`.
- `argv0`           : Set name of executed process.
- `vars`            : Environment variables.

It is defined as an attribute set where each value represents an environment value.

For each environment variable, one can define:
- `value`           : Value of the environment variable. String or list of strings.
- `valueModifier`   : Function that is applied to `value`. Function.
- `action`          : What to do when creating a wrapper. E.g. whether the value should be set, unset, appended or prepended. Function.
- `onMerge`         : What should happen in case of a wrapper merge. Function.

Example of a declarative wrapper:

  with lib.wrappers; with python.pkgs;

  wrapper1 = {
    flags = [ "--verbose" ];
    vars = {
      PYTHONPATH = {
        value = [ networkx numpy ];
        valueModifier = makePythonPath;
#         action = set;
        onMerge = overwrite;
      };
      PATH = {
        value = [ graphviz ];
        valueModifier = makeBinPath;
#         action = prefix ":";
        onMerge = append;
#         sep = ":";
      };
    };
  };


This wrapper sets `PYTHONPATH` and prefixes `PATH`.

Consider also a second wrapper:

  wrapper2 = {
    run = [ ];
    vars =
      PYTHONPATH = {
        value = [ scipy ];
        onMerge = append;
      };
    };
  };

This wrapper also defines `PYTHONPATH`.

These two wrappers can be merged using the `merge` function. E.g., the first wrapper
can be updated with the second one:

  result = merge wrapper1 wrapper2;

On a merge, the `onMerge` attribute of the environment variable of the second
wrapper determines what happens. That means, in this case,

  result = {
    flags = [ "--verbose" ];
    vars = {
      PYTHONPATH = {
        value = [ networkx numpy scipy ];
        valueModifier = python.pkgs.makePythonPath;
        action = set;
        onMerge = append;
      };
      PATH = {
        value = [ graphviz ];
        valueModifier = makeBinPath;
        action = prefix ":";
        onMerge = append;
        sep = ":";
      };
    };
  };


*/

with lib;

let

  hasEqualRequiredAttrs = a: b: let
    # Attributes to check for
    attrsRequiredEqual = [ "action" "extension" "sep" "valueModifier" "onMerge" ];
    # Check whether they are equal, in case they exist in `a`.
    assertEqualAttrValue = attr: a:  b: a.${attr} == b.${attr};
  in all (map assertEqualAttrValue attrsRequiredEqual);

  /* Compute the actual value of an environment variable.

  A `valueModifier` is needed in case `attrs.value` is a list.
  */
  computeValue = attrs:
    if isList attrs.value then attrs.valueModifier attrs.value
    else (attrs.valueModifier or (x: x)) attrs.value;

in rec {

  /* Merge two declarative wrappers.
  */
  merge = a: b: let
    merge_var = envvar: _: b.${envvar}.onMerge a.${envvar} (b.${envvar} or {});
  in a // (mapAttrs merge_var b);


  /* Merge two declarative wrappers using `rules`.

  */

#   mergeUsing = rules: a: b:


  /* Merge two declarative wrappers using the default rules.*/
#   mergeUsingDefaults = mergeUsing defaults;

  /* Generate a list with arguments passed on to `makeWrapper`.*/
  generateMakeWrapperArgs = wrapper: let
    addVars = var: attrs: let
      shouldGenerate = attrs?action && (attrs?value || attrs.action == unset);
    in [] ++ optional shouldGenerate (attrs.action var attrs);
  in []
    ++ optional (hasAttr "argv0" wrapper) "--argv0 ${wrapper.argv0}"
    ++ optional (hasAttr "run" wrapper) "--run ${concatStringsSep " " wrapper.run}"
    ++ optional (hasAttr "flags" wrapper) "--add-flags ${concatStringsSep " " wrapper.flags}"
    ++ optionals (hasAttr "vars" wrapper) (flatten (mapAttrsToList addVars wrapper.vars));

  /* Generate the call(s) to `makeWrapper` or `wrapProgram`.

  Given a wrapper destination, and the wrapper requirements, this function generates
  the invocations for generating a wrapper.

  We need to support the following cases:
  - a specific executable, e.g. "bin/git". This will invoke `wrapProgram` exactly once.
  - a path containing executable, e.g. "bin". This may invoke `wrapProgram` several times.
  - a specific executable along with a source path. This will invoke `makeWrapper` exactly once.

  Furthermore, multiple outputs need to be considered.

  */
  makeWrapperCall = dest: wrapper: let
    empty = list: (length list) == 0;
    argsList = generateMakeWrapperArgs wrapper;
    args = concatStringsSep " " argsList;
  in if (!(empty argsList) || wrapper?source) then
    if wrapper?source then "makeWrapper ${wrapper.source} ${dest} ${args}"
    else "find ${dest} -type f -executable -exec sh -c 'wrapProgram \"$0\" ${args}' {} \\;"
  else "";


  /* The following are functions for merging wrapper attributes.*/

  /* Overwrite the first with the second. */
  overwrite = a: b: b;

  /* Discard the second. */
  discard = a: b: a;

  /* Append the first with the second.

  Note this only makes sense when the environment variable represents a list.
  */
  append = a: b:
    assert hasEqualRequiredAttrs a b;
    b // a.value ++ b.value;

  /* Prepend the first with the second.

  Note this only makes sense when the environment variable represents a list.
  */
  prepend = a: b:
    assert hasEqualRequiredAttrs a b;
    b // a.value ++ b.value;

  /* Throw a message when attempting to merge. */
  raise = msg: a: b: throw msg;


  /* The following functions create, given the environment variable name and its attributes,
  a string that is used in the actual wrapper.
  */

  /* Set an environment variable.
  */
  set = envvar: attrs: "--set ${envvar} ${computeValue attrs}";

  /* Unset an environment variable.
  */
  unset = envvar: attrs: "--unset ${envvar}";

  /* Prefix an environment variable.
  */
  prefix = sep: envvar: attrs: "--prefix ${envvar} ${sep} ${computeValue attrs}";

  /* Suffix an environment variable.
  */
  suffix = sep: envvar: attrs: "--suffix ${envvar} ${sep} ${computeValue attrs}";


  /* The following are default values used throughout Nixpkgs */
  defaults = {
    LD_LIBRARY_PATH = {
      action = set;
      onMerge = prepend;
      valueModifier = makeLibraryPath;
    };
    JAVA_HOME = {
      action = set;
    };
    LUA_PATH = {
      action = set;
      onMerge = prepend;
    };
    PERL5LIB = {
      action = set;
      onMerge = prepend;
      valueModifier = makeFullPerlPath;
    };
    PYTHONHOME = {
      action = set;
#       onMerge = raise "Cannot change PYTHONHOME as it will result in breakage.";
    };
#     PYTHONPATH = {
#       action = set;
#       onMerge = prepend;
#     };
    PATH = {
      action = prefix ":";
      onMerge = prepend;
      valueModifier = makeBinPath;
    };
    XDG_DATA_DIRS = {
      action = prefix ":";
      onMerge = prepend;
      valueModifier = drvs: makeSearchPath "share" ":" drvs;
    };
  };

}
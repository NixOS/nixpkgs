# Assume that there is only one level of nesting in lib.
#
with builtins;
let
  pkgs = import ./.. {};
  inherit (pkgs) lib;
  sets = filter (x: (typeOf lib.${x}) == "set") (attrNames lib);

  filterDocumentedFunctions = set:
    let
      isSet = n: (typeOf set.${n}) == "set";
      hasType = n: set.${n} ? type;
      predicate = x: isSet x && hasType x && lib.${x}.type=="documentedFunction";
    in filter predicate (attrNames set);

  mkDocs = fn: let
    examples = if fn.example != null
      then (assert fn.examples == []; [ fn.example ])
      else fn.examples;
  in { inherit (fn) description; inherit examples; };

  topLevelDocumentedFunctions =
    let
      documentedFunctions = filterDocumentedFunctions lib;
    in map (n: {name = ["lib" n]; docs = mkDocs lib.${n};  }) documentedFunctions;

  find_functions = set:
    let
      set_val = lib.${set};
      documentedFunctions = filterDocumentedFunctions set_val;
    in map (n: {name = ["lib" set n]; docs = mkDocs set_val.${n};  }) documentedFunctions;

  makeDocChapter = topLevel: categorized:
    let
      prefix = ''
        <chapter xmlns="http://docbook.org/ns/docbook"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                 xml:id="chap-lib-functions">

        <title>Library functions</title>
        <para>This paragraph describes the available library functions.</para>
      '';
      postfix = "</chapter>";
      toplevel.prefix = ''
        <section xml:id="sec-lib-functions-top-level">
        <title>Top level functions</title>
        <para>These functions are available under <varname>pkgs.lib</varname></para>
      '';
      toplevel.postfix = "</section>";
      categories.prefix = ''
        <section xml:id="sec-lib-functions-all">
        <title>All library functions</title>
        <para>These functions are available under <varname>pkgs.$category.$name</varname></para>
      '';
      categories.postfix = "</section>";
      makeDocExample = example:
            "<para><emphasis>Example:</emphasis><programlisting>${example}</programlisting></para>";
      makeDocFn = { docs, name }: ''
        <varlistentry>
          <term><option>${concatStringsSep "." name}</option></term>
          <listitem>
          <para>${docs.description}</para>
          ${
            lib.concatStrings (map makeDocExample docs.examples)
          }
          </listitem>
        </varlistentry>
      '';
      makeDocFns = fns: "<variablelist>" + (lib.concatStrings (map makeDocFn fns)) + "</variablelist>";
    in
    prefix +
    toplevel.prefix + (makeDocFns topLevel) + toplevel.postfix +
    categories.prefix + (makeDocFns categorized) + categories.postfix +
    postfix;
in
rec {
  categorized = concatLists (map find_functions sets);
  topLevel = topLevelDocumentedFunctions;
  docChapter = makeDocChapter topLevel categorized;
}

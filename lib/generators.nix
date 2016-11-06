/* Functions that generate widespread config file
 * formats from nix data structures.
 * Tests can be found in ./tests.nix
 */
with import ./trivial.nix;
let
  libStr = import ./strings.nix;
  libAttr = import ./attrsets.nix;

  flipMapAttrs = flip libAttr.mapAttrs;
in

{

  /* Generates an INI-style config file from an
   * attrset of sections to an attrset of key-value pairs.
   *
   * generators.toINI {} {
   *   foo = { hi = "${pkgs.hello}"; ciao = "bar"; };
   *   baz = { "also, integers" = 42; };
   * }
   *
   *> [baz]
   *> also, integers=42
   *>
   *> [foo]
   *> ciao=bar
   *> hi=/nix/store/y93qql1p5ggfnaqjjqhxcw0vqw95rlz0-hello-2.10
   *
   * The mk* configuration attributes can generically change
   * the way sections and key-value strings are generated.
   *
   * For more examples see the test cases in ./tests.nix.
   */
  toINI = {
    # apply transformations (e.g. escapes) to section names
    mkSectionName ? (name: libStr.escape [ "[" "]" ] name),
    # format a setting line from key and value
    mkKeyValue    ? (k: v: "${libStr.escape ["="] k}=${toString v}")
  }: attrsOfAttrs:
    let
        # map function to string for each key val
        mapAttrsToStringsSep = sep: mapFn: attrs:
          libStr.concatStringsSep sep
            (libAttr.mapAttrsToList mapFn attrs);
        mkLine = k: v: mkKeyValue k v + "\n";
        mkSection = sectName: sectValues: ''
          [${mkSectionName sectName}]
        '' + libStr.concatStrings (libAttr.mapAttrsToList mkLine sectValues);
    in
      # map input to ini sections
      mapAttrsToStringsSep "\n" mkSection attrsOfAttrs;
}

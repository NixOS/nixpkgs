{ lib }:

{ /* Automatically convert an attribute set to command-line options.

     This helps protect against malformed command lines and also to reduce
     boilerplate related to command-line construction for simple use cases.

     Example:
       encodeGNUCommandLine { } { foo = "A"; bar = 1; baz = null; qux = true; v = true; }
       => " --bar '1' --foo 'A' --qux -v"
  */
  encodeGNUCommandLine =
    { renderKey ?
        key: if builtins.stringLength key == 1 then "-${key}" else "--${key}"

    , renderOption ?
        key: value:
          if value == null
          then ""
          else " ${renderKey key} ${lib.escapeShellArg value}"

    , renderBool ? key: value: if value then " ${renderKey key}" else ""

    , renderList ? key: value: lib.concatMapStrings renderOption value
    }:
    options:
      let
        render = key: value:
                 if builtins.isBool value
            then renderBool key value
            else if builtins.isList value
            then renderList key value
            else renderOption key value;

      in
        lib.concatStrings (lib.mapAttrsToList render options);
}

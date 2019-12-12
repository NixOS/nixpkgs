{ lib }:

{ /* Automatically convert an attribute set to command-line options.

     This helps protect against malformed command lines and also to reduce
     boilerplate related to command-line construction for simple use cases.

     Example:
       renderOptions { foo = "A"; bar = 1; baz = null; qux = true; v = true; }
       => " --bar '1' --foo 'A' --qux -v"
  */
  renderOptions =
    options:
      let
        render = key: value:
          let
            hyphenate =
              k: if builtins.stringLength k == 1 then "-${k}" else "--${k}";

            renderOption = v: if v == null then "" else " ${hyphenate key} ${lib.escapeShellArg v}";

            renderSwitch = if value then " ${hyphenate key}" else "";

          in
                 if builtins.isBool value
            then renderSwitch
            else if builtins.isList value
            then lib.concatMapStrings renderOption value
            else renderOption value;

      in
        lib.concatStrings (lib.mapAttrsToList render options);
}

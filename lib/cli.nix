{ lib }:

rec {
  /* Automatically convert an attribute set to command-line options.

     This helps protect against malformed command lines and also to reduce
     boilerplate related to command-line construction for simple use cases.

     Example:
       encodeGNUCommandLine
         { }
         { data = builtins.toJSON { id = 0; };

           X = "PUT";

           retry = 3;

           retry-delay = null;

           url = [ "https://example.com/foo" "https://example.com/bar" ];

           silent = false;

           verbose = true;
         };
       => "'-X' 'PUT' '--data' '{\"id\":0}' '--retry' '3' '--url' 'https://example.com/foo' '--url' 'https://example.com/bar' '--verbose'"
  */
  encodeGNUCommandLine =
    options: attrs: lib.escapeShellArgs (toGNUCommandLine options attrs);

  toGNUCommandLine =
    { renderKey ?
        key: if builtins.stringLength key == 1 then "-${key}" else "--${key}"

    , renderOption ?
        key: value:
          if value == null
          then []
          else [ (renderKey key) (builtins.toString value) ]

    , renderBool ? key: value: lib.optional value (renderKey key)

    , renderList ? key: value: lib.concatMap (renderOption key) value
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
        builtins.concatLists (lib.mapAttrsToList render options);
}

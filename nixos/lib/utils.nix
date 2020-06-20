pkgs: with pkgs.lib;

rec {

  # Check whenever fileSystem is needed for boot
  fsNeededForBoot = fs: fs.neededForBoot
                     || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ];

  # Check whenever `b` depends on `a` as a fileSystem
  fsBefore = a: b: a.mountPoint == b.device
                || hasPrefix "${a.mountPoint}${optionalString (!(hasSuffix "/" a.mountPoint)) "/"}" b.mountPoint;

  # Escape a path according to the systemd rules, e.g. /dev/xyzzy
  # becomes dev-xyzzy.  FIXME: slow.
  escapeSystemdPath = s:
   replaceChars ["/" "-" " "] ["-" "\\x2d" "\\x20"]
   (removePrefix "/" s);

  # Returns a system path for a given shell package
  toShellPath = shell:
    if types.shellPackage.check shell then
      "/run/current-system/sw${shell.shellPath}"
    else if types.package.check shell then
      throw "${shell} is not a shell package"
    else
      shell;

  /* Recurse into a list or an attrset, searching for attrs named like
     the value of the "attr" parameter, and return an attrset where the
     names are the corresponding jq path where the attrs were found and
     the values are the values of the attrs.

     Example:
       recursiveGetAttrWithJqPrefix {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
               };
             };
           }
         ];
       } "_secret" -> { ".example[1].relevant.secret" = "/path/to/secret"; }
  */
  recursiveGetAttrWithJqPrefix = item: attr:
    let
      recurse = prefix: item:
        if item ? ${attr} then
          nameValuePair prefix item.${attr}
        else if isAttrs item then
          map (name: recurse (prefix + "." + name) item.${name}) (attrNames item)
        else if isList item then
          imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
        else
          [];
    in listToAttrs (flatten (recurse "" item));

  /* Takes an attrset and a file path and generates a bash snippet that
     outputs a JSON file at the file path with all instances of

     { _secret = "/path/to/secret" }

     in the attrset replaced with the contents of the file
     "/path/to/secret" in the output JSON.

     When a configuration option accepts an attrset that is finally
     converted to JSON, this makes it possible to let the user define
     arbitrary secret values.

     Example:
       If the file "/path/to/secret" contains the string
       "topsecretpassword1234",

       genJqSecretsReplacementSnippet {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
               };
             };
           }
         ];
       } "/path/to/output.json"

       would generate a snippet that, when run, outputs the following
       JSON file at "/path/to/output.json":

       {
         "example": [
           {
             "irrelevant": "not interesting"
           },
           {
             "ignored": "ignored attr",
             "relevant": {
               "secret": "topsecretpassword1234"
             }
           }
         ]
       }
  */
  genJqSecretsReplacementSnippet = genJqSecretsReplacementSnippet' "_secret";

  # Like genJqSecretsReplacementSnippet, but allows the name of the
  # attr which identifies the secret to be changed.
  genJqSecretsReplacementSnippet' = attr: set: output:
    let
      secrets = recursiveGetAttrWithJqPrefix set attr;
    in ''
      if [[ -h '${output}' ]]; then
        rm '${output}'
      fi
    ''
    + concatStringsSep
        "\n"
        (imap1 (index: name: "export secret${toString index}=$(<'${secrets.${name}}')")
               (attrNames secrets))
    + "\n"
    + "${pkgs.jq}/bin/jq >'${output}' '"
    + concatStringsSep
      " | "
      (imap1 (index: name: ''${name} = $ENV.secret${toString index}'')
             (attrNames secrets))
    + ''
      ' <<'EOF'
      ${builtins.toJSON set}
      EOF
    '';
}

with import ./strings.nix;

/* Helpers for creating lisp S-exprs for the Apple sandbox

lib.sandbox.allowFileRead [ "/usr/bin/file" ];
  # => "(allow file-read* (literal \"/usr/bin/file\"))";

lib.sandbox.allowFileRead {
  literal = [ "/usr/bin/file" ];
  subpath = [ "/usr/lib/system" ];
}
  # => "(allow file-read* (literal \"/usr/bin/file\") (subpath \"/usr/lib/system\"))"
*/

let

sexp = tokens: "(" + builtins.concatStringsSep " " tokens + ")";
generateFileList = files:
  if builtins.isList files
    then concatMapStringsSep " " (x: sexp [ "literal" ''"${x}"'' ]) files
    else if builtins.isString files
      then generateFileList [ files ]
      else concatStringsSep " " (
        (map (x: sexp [ "literal" ''"${x}"'' ]) (files.literal or [])) ++
        (map (x: sexp [ "subpath" ''"${x}"'' ]) (files.subpath or []))
      );
applyToFiles = f: act: files: f "${act} ${generateFileList files}";
genActions = actionName: let
  action = feature: sexp [ actionName feature ];
  self = {
    "${actionName}" = action;
    "${actionName}File" = applyToFiles action "file*";
    "${actionName}FileRead" = applyToFiles action "file-read*";
    "${actionName}FileReadMetadata" = applyToFiles action "file-read-metadata";
    "${actionName}DirectoryList" = self."${actionName}FileReadMetadata";
    "${actionName}FileWrite" = applyToFiles action "file-write*";
    "${actionName}FileWriteMetadata" = applyToFiles action "file-write-metadata";
  };
  in self;

in

genActions "allow" // genActions "deny" // {
  importProfile = derivation: ''
    (import "${derivation}")
  '';
}

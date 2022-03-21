{ lib, config, pkgs }: with lib;

rec {

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommand (builtins.unsafeDiscardStringContext (builtins.baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';

  # Check whenever fileSystem is needed for boot.  NOTE: Make sure
  # pathsNeededForBoot is closed under the parent relationship, i.e. if /a/b/c
  # is in the list, put /a and /a/b in as well.
  pathsNeededForBoot = [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/var/lib/nixos" "/etc" "/usr" ];
  fsNeededForBoot = fs: fs.neededForBoot || elem fs.mountPoint pathsNeededForBoot;

  # Check whenever `b` depends on `a` as a fileSystem
  fsBefore = a: b:
    let
      # normalisePath adds a slash at the end of the path if it didn't already
      # have one.
      #
      # The reason slashes are added at the end of each path is to prevent `b`
      # from accidentally depending on `a` in cases like
      #    a = { mountPoint = "/aaa"; ... }
      #    b = { device     = "/aaaa"; ... }
      # Here a.mountPoint *is* a prefix of b.device even though a.mountPoint is
      # *not* a parent of b.device. If we add a slash at the end of each string,
      # though, this is not a problem: "/aaa/" is not a prefix of "/aaaa/".
      normalisePath = path: "${path}${optionalString (!(hasSuffix "/" path)) "/"}";
      normalise = mount: mount // { device = normalisePath (toString mount.device);
                                    mountPoint = normalisePath mount.mountPoint;
                                    depends = map normalisePath mount.depends;
                                  };

      a' = normalise a;
      b' = normalise b;

    in hasPrefix a'.mountPoint b'.device
    || hasPrefix a'.mountPoint b'.mountPoint
    || any (hasPrefix a'.mountPoint) b'.depends;

  # Escape a path according to the systemd rules, e.g. /dev/xyzzy
  # becomes dev-xyzzy.  FIXME: slow.
  escapeSystemdPath = s:
   replaceChars ["/" "-" " "] ["-" "\\x2d" "\\x20"]
   (removePrefix "/" s);

  # Quotes an argument for use in Exec* service lines.
  # systemd accepts "-quoted strings with escape sequences, toJSON produces
  # a subset of these.
  # Additionally we escape % to disallow expansion of % specifiers. Any lone ;
  # in the input will be turned it ";" and thus lose its special meaning.
  # Every $ is escaped to $$, this makes it unnecessary to disable environment
  # substitution for the directive.
  escapeSystemdExecArg = arg:
    let
      s = if builtins.isPath arg then "${arg}"
        else if builtins.isString arg then arg
        else if builtins.isInt arg || builtins.isFloat arg then toString arg
        else throw "escapeSystemdExecArg only allows strings, paths and numbers";
    in
      replaceChars [ "%" "$" ] [ "%%" "$$" ] (builtins.toJSON s);

  # Quotes a list of arguments into a single string for use in a Exec*
  # line.
  escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;

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

      inherit_errexit_enabled=0
      shopt -pq inherit_errexit && inherit_errexit_enabled=1
      shopt -s inherit_errexit
    ''
    + concatStringsSep
        "\n"
        (imap1 (index: name: ''
                  secret${toString index}=$(<'${secrets.${name}}')
                  export secret${toString index}
                '')
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
      (( ! $inherit_errexit_enabled )) && shopt -u inherit_errexit
    '';

  systemdUtils = {
    lib = import ./systemd-lib.nix { inherit lib config pkgs; };
    unitOptions = import ./systemd-unit-options.nix { inherit lib systemdUtils; };
  };
}

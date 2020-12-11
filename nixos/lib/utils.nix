pkgs: with pkgs.lib;

rec {

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommandNoCC (builtins.unsafeDiscardStringContext (builtins.baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';

  # Check whenever fileSystem is needed for boot.  NOTE: Make sure
  # pathsNeededForBoot is closed under the parent relationship, i.e. if /a/b/c
  # is in the list, put /a and /a/b in as well.
  pathsNeededForBoot = [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ];
  fsNeededForBoot = fs: fs.neededForBoot || elem fs.mountPoint pathsNeededForBoot;

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

  pam = rec {
    entryTypes = [ "account" "auth" "password" "session" ];

    returnCode = types.enum [
      "success" "open_err" "symbol_err" "service_err" "system_err" "buf_err"
      "perm_denied" "auth_err" "cred_insufficient" "authinfo_unavail"
      "user_unknown" "maxtries" "new_authtok_reqd" "acct_expired" "session_err"
      "cred_unavail" "cred_expired" "cred_err" "no_module_data" "conv_err"
      "authtok_err" "authtok_recover_err" "authtok_lock_busy"
      "authtok_disable_aging" "try_again" "ignore" "abort" "authtok_expired"
      "module_unknown" "bad_item" "conv_again" "incomplete" "default"
    ];

    action = types.either types.int (types.enum ["ignore" "bad" "die" "ok" "done" "reset"]);

    controlType = types.either
      (types.enum [ "required" "requisite" "sufficient" "optional" "include" "substack" ])
      (types.addCheck (types.attrsOf action) (x: all returnCode.check (attrNames x)));

    anyEnable = pamCfg: name: any (attrByPath [ "modules" name "enable" ] false) (attrValues pamCfg.services);

    isTypeEnabled = svcCfg: type: all (t: t != type) svcCfg.excludeDefaults;

    # See nixos/modules/security/pam/modules/motd.nix for a simple example
    # See nixos/modules/security/pam/modules/unix.nix for a more complex one
    mkPamModule =
      { name
      , mkModuleOptions ? (global: {})
      , mkSvcConfigCondition ? (svcCfg: true)
      , mkAccountConfig ? (svcCfg: {})
      , mkAuthConfig ? (svcCfg: {})
      , mkPasswordConfig ? (svcCfg: {})
      , mkSessionConfig ? (svcCfg: {})
      , extraSubmodules ? []
      }:
      {
        services = mkOption {
          type = with types; attrsOf (submoduleWith {
            shorthandOnlyDefinesConfig = true;
            modules = extraSubmodules ++ [
              ({ config, ... }: {
                options = if name != null then {
                  modules."${name}" = mkModuleOptions false;
                } else {
                  modules = mkModuleOptions false;
                };

                config = mkIf (mkSvcConfigCondition config) {
                  account = mkIf (isTypeEnabled config "account") (mkAccountConfig config);
                  auth = mkIf (isTypeEnabled config "auth") (mkAuthConfig config);
                  password = mkIf (isTypeEnabled config "password") (mkPasswordConfig config);
                  session = mkIf (isTypeEnabled config "session") (mkSessionConfig config);
                };
              })
            ];
          });
        };

        modules = if name != null then {
          "${name}" = mkModuleOptions true;
        } else mkModuleOptions true;
      };
  };
}

{ lib }:

with lib;

rec {
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
}

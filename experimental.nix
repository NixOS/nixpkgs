let
  nixpkgs = import ./. {};
  inherit (nixpkgs) lib;

  # TODO: Automate it.
  BACKWARD = {
    with_alsa = [ "alsaSupport" "withAlsa" ];
  };
  FORWARD = {
    alsaSupport = "with_alsa";
    withAlsa = "with_alsa";
  };

  victim = nixpkgs.cmus.override;

  oldArgs = lib.functionArgs victim;

  # Since we don't know what was the original deprecated name used by the
  # package (if any, really), we have to extend original signature with all
  # known deprecated names.
  #
  # Which means that if before it had "alsaSupport", now override can also be
  # called with "withAlsa". And let's not bring what will happen if somebody
  # provides both. Goal is to keep old code working, not preventing user from
  # defying warnings and doing something stupid.
  mkExtraArgs = name: value:
    if lib.hasAttr name BACKWARD
    then map (n: { name = n; value = value; }) (lib.getAttr name BACKWARD)
    else [];

  patch = builtins.listToAttrs (builtins.concatLists (lib.mapAttrsToList mkExtraArgs oldArgs));
  newArgs = oldArgs // patch;

  newFunctor = args':
    let f = name: value:
            let renamed = lib.getAttr name FORWARD;
                warning = "Feature parameter '" + name + "' is deprecated in favor of '" + renamed + "'.";
            in if lib.hasAttr name FORWARD && lib.hasAttr (lib.getAttr name FORWARD) BACKWARD
            then lib.warn warning { name = renamed; inherit value; }
            else { inherit name value; };
        args = if builtins.isAttrs args' then builtins.listToAttrs (lib.mapAttrsToList f args') else args';
    in victim args;
in {
  cmus2 = newFunctor { with_alsa = false; };
  cmus3 = newFunctor { alsaSupport = false; };
}

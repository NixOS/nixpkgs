{lib, pkgs} :
let inherit (lib) nv nvs; in
{
  # see for example:
  # - development/interpreters/php_configurable/default.nix
  # - .. search composableDerivation in all-packages.nix ..
  #
  # You should be able to override anything you like easily
  # grep the mailinglist by title "python proposal" (dec 08)
  # -> http://mail.cs.uu.nl/pipermail/nix-dev/2008-December/001571.html
  # to see why this got complicated when using all its features
  # TODO add newer example using new syntax (kernel derivation proposal -> mailinglist)
  composableDerivation = {
        mkDerivation ? pkgs.stdenv.mkDerivation,

        # list of functions to be applied before defaultOverridableDelayableArgs removes removeAttrs names
        # prepareDerivationArgs handles derivation configurations
        applyPreTidy ? [ lib.prepareDerivationArgs ],

        # consider adding addtional elements by derivation.merge { removeAttrs = ["elem"]; };
        removeAttrs ? ["cfg" "flags"]

      }: (lib.defaultOverridableDelayableArgs ( a: mkDerivation a) 
         {
           inherit applyPreTidy removeAttrs;
         }).merge;

  # some utility functions
  # use this function to generate flag attrs for prepareDerivationArgs
  # E nable  D isable F eature
  edf = {name, feat ? name, enable ? {}, disable ? {} , value ? ""}:
    nvs name {
    set = {
      configureFlags = ["--enable-${feat}${if value == "" then "" else "="}${value}"];
    } // enable;
    unset = {
      configureFlags = ["--disable-${feat}"];
    } // disable;
  };

  # same for --with and --without-
  # W ith or W ithout F eature
  wwf = {name, feat ? name, enable ? {}, disable ? {}, value ? ""}:
    nvs name {
    set = enable // {
      configureFlags = ["--with-${feat}${if value == "" then "" else "="}${value}"]
                       ++ lib.maybeAttr "configureFlags" [] enable;
    };
    unset = disable // {
      configureFlags = ["--without-${feat}"]
                       ++ lib.maybeAttr "configureFlags" [] disable;
    };
  };
}

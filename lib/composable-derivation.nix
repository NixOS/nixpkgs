{lib, pkgs}:
let inherit (lib) nv nvs; in
{

  # composableDerivation basically mixes these features:
  # - fix function
  # - mergeAttrBy
  # - provides shortcuts for "options" such as "--enable-foo" and adding
  #   buildInputs, see php example
  #
  # It predates styles which are common today, such as
  #  * the config attr
  #  * mkDerivation.override feature
  #  * overrideDerivation (lib/customization.nix)
  #
  # Some of the most more important usage examples (which could be rewritten if it was important):
  # * php
  # * postgis
  # * vim_configurable
  #
  # A minimal example illustrating most features would look like this:
  # let base = composableDerivation { (fixed: let inherit (fixed.fixed) name in {
  #    src = fetchurl {
  #    }
  #    buildInputs = [A];
  #    preConfigre = "echo ${name}";
  #    # attention, "name" attr is missing, thus you cannot instantiate "base".
  # }
  # in {
  #  # These all add name attribute, thus you can instantiate those:
  #  v1 = base.merge   ({ name = "foo-add-B"; buildInputs = [B]; });       // B gets merged into buildInputs
  #  v2 = base.merge   ({ name = "mix-in-pre-configure-lines" preConfigre = ""; });
  #  v3 = base.replace ({ name = "foo-no-A-only-B;" buildInputs = [B]; });
  # }
  #
  # So yes, you can think about it being something like nixos modules, and
  # you'd be merging "features" in one at a time using .merge or .replace
  # Thanks Shea for telling me that I rethink the documentation ..
  #
  # issues:
  # * its complicated to understand
  # * some "features" such as exact merge behaviour are buried in mergeAttrBy
  #   and defaultOverridableDelayableArgs assuming the default behaviour does
  #   the right thing in the common case
  # * Eelco once said using such fix style functions are slow to evaluate
  # * Too quick & dirty. Hard to understand for others. The benefit was that
  #   you were able to create a kernel builder like base derivation and replace
  #   / add patches the way you want without having to declare function arguments
  #
  # nice features:
  # declaring "optional features" is modular. For instance:
  #   flags.curl = {
  #     configureFlags = ["--with-curl=${curl.dev}" "--with-curlwrappers"];
  #     buildInputs = [curl openssl];
  #   };
  #   flags.other = { .. }
  # (Example taken from PHP)
  #
  # alternative styles / related features:
  #  * Eg see function supporting building the kernel
  #  * versionedDerivation (discussion about this is still going on - or ended)
  #  * composedArgsAndFun
  #  * mkDerivation.override
  #  * overrideDerivation
  #  * using { .., *Support ? false }: like configurable options.
  # To find those examples use grep
  #
  # To sum up: It exists for historical reasons - and for most commonly used
  # tasks the alternatives should be used
  #
  # If you have questions about this code ping Marc Weber.
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

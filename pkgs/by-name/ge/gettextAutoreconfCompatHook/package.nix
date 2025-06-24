{
  makeSetupHook,
  writeText,
  gettext,
}:

# Since gettext 0.24.1, m4 macros are installed in ${gettext}/share/gettext/m4
# instead of ${gettext}/share/aclocal.
# As a result, packages depending on gettext m4 macros but without
# AM_GNU_GETTEXT_VERSION in configure.ac will fail to build during autoreconf,
# with errors like:
#   AC_LIB_PREPARE_PREFIX: command not found
#   error: possibly undefined macro: AC_LIB_PREPARE_PREFIX
#   error: possibly undefined macro: AM_ICONV
#
# For the intention of this breaking change, see:
#   https://savannah.gnu.org/bugs/index.php?67090
#
# This hook restores the old behavior by adding ${gettext}/share/gettext/m4
# to ACLOCAL_PATH.
# It should only be used for packages that use autoreconf and without
# upstream fixes for gettext 0.24.1+.

makeSetupHook { name = "gettext-autoreconf-compat-hook"; } (
  writeText "setup-hook.sh" ''
    addGettextAclocalHook() {
        addToSearchPath "ACLOCAL_PATH" "${gettext}/share/gettext/m4"
    }

    prependToVar preConfigurePhases addGettextAclocalHook
  ''
)

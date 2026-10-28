{
  lib,
  makeSetupHook,
  autoconf,
  automake,
  gettext,
  libtool,
}:
makeSetupHook {
  name = "autoreconf-hook";
  propagatedBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];
  meta.license = lib.licenses.mit;
} ./autoreconf.sh

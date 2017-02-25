{
  kdeApp, kdeWrapper,
  ecm, kdoctools,
  grantlee, kconfig, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils,
  kdelibs4support, khtml, kservice, xapian
}:

let
  unwrapped =
    kdeApp {
      name = "khelpcenter";
      nativeBuildInputs = [ ecm kdoctools ];
      buildInputs = [
        grantlee kdelibs4support khtml ki18n kconfig kcoreaddons kdbusaddons
        kinit kcmutils kservice xapian
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/khelpcenter" ];
}

{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  gpgme, kcmutils, kitemmodels, kmime, libkleo
}:

let
  unwrapped =
    kdeApp {
      name = "kleopatra";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        gpgme kcmutils kitemmodels kmime libkleo
      ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kleopatra" ];
}

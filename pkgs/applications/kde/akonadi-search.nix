{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, kcalcore, kcontacts, kmime, krunner, xapian
}:

#let
#  unwrapped =
    kdeApp {
      name = "akonadi-search";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.vandenoever ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [
        akonadi akonadi-mime kcalcore kcontacts kmime krunner xapian
      ];
    }
#;
#in
#kdeWrapper {
#  inherit unwrapped;
#  targets = [
#    "bin/akonadi_indexing_agent"
#  ];
#}

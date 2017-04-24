{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules,
  kcompletion, kconfigwidgets, kdbusaddons, kdesignerplugin, kiconthemes,
  kio,
  boost, kitemmodels
}:

#let
#  unwrapped =
    kdeApp {
      name = "akonadi";
      meta = {
        license = [ lib.licenses.lgpl21 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ extra-cmake-modules ];
      buildInputs = [
        kcompletion kconfigwidgets kdbusaddons kdesignerplugin kiconthemes kio
      ];
      propagatedBuildInputs = [ boost kitemmodels ];
    }
#;
#in
#kdeWrapper {
#  inherit unwrapped;
#  targets = [
#    "bin/akonadi2xml"
#    "bin/akonadi_agent_launcher"
#    "bin/akonadi_agent_server"
#    "bin/akonadi_control"
#    "bin/akonadi_knut_resource"
#    "bin/akonadi_rds"
#    "bin/akonadictl"
#    "bin/akonadiselftest"
#    "bin/akonadiserver"
#    "bin/akonaditest"
#    "bin/asapcat"
#  ];
#}

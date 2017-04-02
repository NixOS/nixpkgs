{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kdelibs4support, kdnssd, libvncserver, libXtst
}:

let
  unwrapped =
    kdeApp {
      name = "krfb";
      meta = {
        license = with lib.licenses; [ gpl2 fdl12 ];
        maintainers = with lib.maintainers; [ jerith666 ];
      };
      nativeBuildInputs = [ extra-cmake-modules kdoctools ];
      propagatedBuildInputs = [ kdelibs4support kdnssd libvncserver libXtst ];
    };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/krfb" ];
}

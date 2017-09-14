name: args:

{ mkDerivation, cmake, extra-cmake-modules, gettext, kdoctools }:

mkDerivation (args // {
  sname = "kde-l10n-${name}";
  name = "kde-l10n-${name}-qt5";

  outputs = [ "out" ];

  nativeBuildInputs =
    [ cmake extra-cmake-modules gettext kdoctools ]
    ++ (args.nativeBuildInputs or []);

  preConfigure = ''
    sed -e 's/add_subdirectory(4)//' -i CMakeLists.txt
    ${args.preConfigure or ""}
  '';

  preFixup = ''
    propagatedBuildInputs=
    propagatedNativeBuildInputs=
  '';
})

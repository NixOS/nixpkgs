{ lib
, mkDerivation
, cmake
, corrosion
, extra-cmake-modules
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami-addons
, kirigami2
, knotifications
, kpurpose
, kwindowsystem
, qtfeedback
, qtquickcontrols2
, qqc2-desktop-style
, qtwebengine
, rustPlatform
, srcs

# These must be updated in tandem with package updates.
, cargoShaForVersion ? "23.04.0"
, cargoSha256 ? "sha256-96Qe8zdLZdOrU/t6J+JJ6V0PXyFOnJF18qDrk4PZGsA="
}:

# Guard against incomplete updates.
# Values are provided as callPackage inputs to enable easier overrides through overlays.
if cargoShaForVersion != srcs.angelfish.version
then builtins.throw ''
  angelfish package update is incomplete.
         Hash for cargo dependencies is declared for version ${cargoShaForVersion}, but we're building ${srcs.angelfish.version}.
         Update the cargoSha256 and cargoShaForVersion for angelfish.
'' else

mkDerivation rec {
  pname = "angelfish";

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = srcs.angelfish.src;
    name = "${pname}-${srcs.angelfish.version}";
    sha256 = cargoSha256;
  };

  nativeBuildInputs = [
    cmake
    corrosion
    extra-cmake-modules
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
    qtfeedback
    qtquickcontrols2
    qqc2-desktop-style
    qtwebengine
  ];

  meta = with lib; {
    description = "Web browser for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

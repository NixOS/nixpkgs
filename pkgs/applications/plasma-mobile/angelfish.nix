{ lib
, mkDerivation
, cmake
, corrosion
, extra-cmake-modules
, gcc12
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
, qtwebengine
, rustPlatform
, srcs

# These must be updated in tandem with package updates.
, cargoShaForVersion ? "23.01.0"
, cargoSha256 ? "sha256-dIXA875HsG56baHrTWw9L560n4s0wRv6Ag/2oj1x0gk="
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
    gcc12 # doesn't build with GCC 9 from stdenv on aarch64
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
    qtwebengine
  ];

  meta = with lib; {
    description = "Web browser for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

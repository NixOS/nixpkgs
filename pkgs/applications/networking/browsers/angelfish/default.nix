{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, corrosion
, extra-cmake-modules
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami2
, knotifications
, kpurpose
, kwindowsystem
, qtquickcontrols2
, qtwebengine
, rustPlatform
}:

mkDerivation rec {
  pname = "angelfish";
  version = "1.8.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-mobile";
    repo = "angelfish";
    rev = "v${version}";
    sha256 = "0pj2kw7lmxh7diwdcmk24qxqslavhvf23r2i6h549gbllbzk219f";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0cyrmhlg0kjr14842ckbjdljc2zc28al0y9i8w5l0qzr18krgc0m";
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

  cmakeFlags = [
    "-DRust_CARGO=${rustPlatform.rust.cargo}/bin/cargo"
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
    qtquickcontrols2
    qtwebengine
  ];

  meta = with lib; {
    description = "Web browser for Plasma Mobile";
    homepage = "https://apps.kde.org/en/mobile.angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

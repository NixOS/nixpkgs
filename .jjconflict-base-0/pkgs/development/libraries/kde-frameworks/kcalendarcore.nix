{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  libical,
}:

mkDerivation {
  pname = "kcalendarcore";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  propagatedBuildInputs = [ libical ];
  outputs = [
    "out"
    "dev"
  ];
}

{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, qtsystems
}:

mkDerivation {
  pname = "mauiman";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtsystems
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauiman";
    description = "Maui Manager Library. Server and public library API";
    maintainers = with maintainers; [ dotlambda ];
  };
}

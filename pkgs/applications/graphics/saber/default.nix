{ lib
, flutter
, fetchFromGitHub
, cmake
}:

flutter.mkFlutterApp rec {
  pname = "saber";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "adil192";
    repo = "saber";
    rev = "v${version}";
    hash = "sha256-uLraG7ZDmG+Z2MV6H15v8ZrQYdELQp1ypU3IFNBq/14=";
  };

  vendorHash = "sha256-U2VROQPIRxF8KVupcnQTqOoJtiaQz+UMXn4O0AD8B+8=";

  meta = {
    description = "Cross-platform libre handwritten notes app";
    homepage = "https://github.com/adil192/saber";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}

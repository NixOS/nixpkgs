{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "espmonitor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espmonitor";
    rev = "v${version}";
    sha256 = "hWFdim84L2FfG6p9sEf+G5Uq4yhp5kv1ZMdk4sMHa+4=";
  };

  cargoHash = "sha256-Fb/xJLhmInYOanJC6XGsxxsCJNCLvHDe04+wtvXMecE=";

<<<<<<< HEAD
  meta = {
    description = "Cargo tool for monitoring ESP32/ESP8266 execution";
    homepage = "https://github.com/esp-rs/espmonitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ xanderio ];
=======
  meta = with lib; {
    description = "Cargo tool for monitoring ESP32/ESP8266 execution";
    homepage = "https://github.com/esp-rs/espmonitor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xanderio ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

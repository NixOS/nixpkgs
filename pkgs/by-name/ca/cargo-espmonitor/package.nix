{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "espmonitor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espmonitor";
    rev = "v${finalAttrs.version}";
    sha256 = "hWFdim84L2FfG6p9sEf+G5Uq4yhp5kv1ZMdk4sMHa+4=";
  };

  cargoHash = "sha256-Fb/xJLhmInYOanJC6XGsxxsCJNCLvHDe04+wtvXMecE=";

  meta = {
    description = "Cargo tool for monitoring ESP32/ESP8266 execution";
    homepage = "https://github.com/esp-rs/espmonitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ xanderio ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mqtt_cpp";
  version = "13.2.4";

  src = fetchFromGitHub {
    owner = "redboltz";
    repo = "mqtt_cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EZo7Wk2ZtbF85VSSYyZgeB2CJJIKLRmQlhqD42YW+yI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  meta = {
    description = "MQTT client/server for C++14 based on Boost.Asio";
    homepage = "https://github.com/redboltz/mqtt_cpp";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ spalf ];
    platforms = lib.platforms.unix;
  };
})

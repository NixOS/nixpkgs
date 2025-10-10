{
  fetchFromGitHub,
  stdenv,
  lib,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "meowhttp";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "maukkis";
    repo = "meowHttp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/V9k84Cew9IT63DeuOVG/4KxErbQz3x/6579QZ/eU60=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "C++ library to send https and wss requests";
    homepage = "https://github.com/maukkis/meowHttp";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maukkis ];
    license = lib.licenses.asl20;
  };
})

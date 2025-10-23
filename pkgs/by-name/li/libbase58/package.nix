{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libgcrypt,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libbase58";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "bitcoin";
    repo = "libbase58";
    rev = "v${version}";
    hash = "sha256-CU55V89GbcYnrhwTPFMd13EGeCk/x9nQswUZ2JsYsUU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libgcrypt ];

  meta = {
    description = "C library for Bitcoin's base58 encoding";
    homepage = "https://github.com/bitcoin/libbase58";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nagy ];
    mainProgram = "base58";
    platforms = lib.platforms.all;
  };
}

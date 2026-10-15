{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  help2man,
  curl,
}:

stdenv.mkDerivation {
  pname = "libykclient";
  version = "unstable-2019-03-18";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-c-client";
    rev = "ad9eda6aac4c3f81784607c30b971f4a050b5c2e";
    hash = "sha256-0oMCAISaMRSVyHCXkihUASPqtJQ+cUgNjNdTsZ9MYQU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
  ];
  buildInputs = [ curl ];

  meta = {
    description = "Yubikey C client library";
    mainProgram = "ykclient";
    homepage = "https://developers.yubico.com/yubico-c-client";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}

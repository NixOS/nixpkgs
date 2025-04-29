{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "mdns";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mjansson";
    repo = "mdns";
    rev = version;
    hash = "sha256-2uv+Ibnbl6hsdjFqPhcHXbv+nIEIT4+tgtwGndpZCqo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Public domain mDNS/DNS-SD library in C";
    homepage = "https://github.com/mjansson/mdns";
    changelog = "https://github.com/mjansson/mdns/blob/${src.rev}/CHANGELOG";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}

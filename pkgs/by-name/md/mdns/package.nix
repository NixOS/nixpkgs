{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdns";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mjansson";
    repo = "mdns";
    rev = finalAttrs.version;
    hash = "sha256-2uv+Ibnbl6hsdjFqPhcHXbv+nIEIT4+tgtwGndpZCqo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # Fix configure with cmake4
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  meta = {
    description = "Public domain mDNS/DNS-SD library in C";
    homepage = "https://github.com/mjansson/mdns";
    changelog = "https://github.com/mjansson/mdns/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
})

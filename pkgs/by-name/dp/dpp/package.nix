{
  stdenv,
  fetchFromGitHub,
  cmake,
  libopus,
  openssl,
  zlib,
  libsodium,
  pkg-config,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dpp";
  version = "10.0.35";

  src = fetchFromGitHub {
    owner = "brainboxdotcc";
    repo = "DPP";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gdHcYBIQzVfQsUyC2hxeMkmm5lMDjaY7isBidSxhc80=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    libsodium
    libopus
  ];

  meta = {
    description = "Discord C++ Library";
    longDescription = ''
      D++ (DPP) is a lightweight and simple library for Discord written in modern C++.
      It is designed to cover as much of the API specification as possible and to have
      an incredibly small memory footprint, even when caching large amounts of data.
      This package contains version ${finalAttrs.version} of the DPP library.
    '';
    homepage = "https://github.com/brainboxdotcc/DPP";
    changelog = "https://github.com/brainboxdotcc/DPP/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xbz ];
    platforms = lib.platforms.linux;
  };
})

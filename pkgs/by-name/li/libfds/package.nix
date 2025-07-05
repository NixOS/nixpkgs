{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libxml2,
  lz4,
  zstd,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libfds";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libfds";
    tag = "v${version}";
    hash = "sha256-rYEUjMnKPxE0HxPZZ58DwrhPb89NpIjEnftqbsfkvTU=";
  };

  buildInputs = [
    libxml2
    lz4
    zstd
  ];
  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Components for parsing and processing IPFIX Messages";
    homepage = "https://github.com/CESNET/libfds";
    changelog = "https://github.com/CESNET/libfds/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jaroslavpesek ];
  };
}

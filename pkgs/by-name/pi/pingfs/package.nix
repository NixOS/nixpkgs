{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  fuse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pingfs";
  version = "0-unstable-2020-05-24";

  src = fetchFromGitHub {
    owner = "yarrick";
    repo = "pingfs";
    rev = "f2f2b5ff1893d0531d0a0d1ea2ae96b52dcf780e";
    hash = "sha256-G0j2vJ2cnmj9TgZ9WHAq/3a7ZD269rLbNtxgm2WHKMs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    fuse
  ];

  installPhase = ''
    runHook preInstall

    installBin pingfs

    runHook postInstall
  '';

  env.NIX_CFLAGS_COMPILE = "-D_FILE_OFFSET_BITS=64";

  meta = {
    description = "Store your data in ICMP ping packets";
    homepage = "https://code.kryo.se/pingfs/";
    downloadPage = "https://github.com/yarrick/pingfs";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
})

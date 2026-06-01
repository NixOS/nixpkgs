{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adslib";
  version = "0-unstable-2026-04-27";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "ADS";
    rev = "77953d58f2690436e82db9954e2e55878c5edaa4";
    hash = "sha256-UDPuzqD1krEZa7436k1NvE0lJUmNYG4kiP5fstoRDMc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  postInstall = ''
    # Downstream consumers (e.g. pyads) load the shared library as
    # `adslib.so` rather than the meson default `libadslib.so`.
    ln -s libadslib.so $out/lib/adslib.so
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Beckhoff protocol to communicate with TwinCAT devices";
    homepage = "https://github.com/stlehmann/ADS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
    platforms = lib.platforms.linux;
  };
})

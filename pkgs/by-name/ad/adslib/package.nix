{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adslib";
  version = "113.0.34-1";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "ADS";
    tag = finalAttrs.version;
    hash = "sha256-Kh8BDioZdwSdATHPgZ7Ar3/E0y3eRRpG/38/2uHZEEQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  postInstall = ''
    # Downstream consumers (e.g. pyads) load the shared library as
    # `adslib.so` rather than the meson default `libAdsLib.so`.
    ln -s libAdsLib.so $out/lib/adslib.so
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Beckhoff protocol to communicate with TwinCAT devices";
    homepage = "https://github.com/stlehmann/ADS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
    platforms = lib.platforms.linux;
  };
})

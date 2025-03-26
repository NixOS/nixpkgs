{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  libpulseaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ringrtc-bin";
  version = "2.50.2";
  src = fetchzip {
    url = "https://build-artifacts.signal.org/libraries/ringrtc-desktop-build-v${finalAttrs.version}.tar.gz";
    hash = "sha256-hNlz+gSulyJ//FdbPvY/5OHbtJ4rEUdi9/SHJDX6gZE=";
  };

  installPhase = ''
    cp -r . $out
  '';

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ libpulseaudio ];
  meta = {
    homepage = "https://github.com/signalapp/ringrtc";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

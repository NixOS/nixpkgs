{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  libpulseaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ringrtc-bin";
  version = "2.50.3";
  src = fetchzip {
    url = "https://build-artifacts.signal.org/libraries/ringrtc-desktop-build-v${finalAttrs.version}.tar.gz";
    hash = "sha256-UJqH/UiT9j36r6fr673CP/Z4lGaSPXIzAkf72YZfExo=";
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

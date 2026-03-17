{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  libremidi,
  pkg-config,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-midi-mg";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "nhielost";
    repo = "obs-midi-mg";
    tag = finalAttrs.version;
    hash = "sha256-enWqdEUIzGE9QWK8+u6hKIXmORZXhzK0pbYza6R7SFA=";
  };

  buildInputs = [
    obs-studio
    libremidi
    qtbase
  ];

  env.QTDIR = qtbase.dev;

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postUnpack = ''
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
    chmod -R +w $sourceRoot/deps/libremidi
  '';

  postInstall = ''
    rm -rf "$out/obs-plugins" "$out/data"
  '';

  cmakeFlags = [
    # PipeWire support currently disabled in libremidi dependency.
    # see https://github.com/NixOS/nixpkgs/pull/374469
    (lib.cmakeBool "LIBREMIDI_NO_PIPEWIRE" true)
    (lib.cmakeBool "ENABLE_QT" true)
  ];

  meta = {
    description = "Allows MIDI devices to interact with OBS Studio";
    homepage = "https://github.com/nhielost/obs-midi-mg";
    changelog = "https://github.com/nhielost/obs-midi-mg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthiabeyer ];
    inherit (obs-studio.meta) platforms;
  };
})

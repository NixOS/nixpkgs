{
  lib,
  stdenv,
  fetchFromGitHub,
  bankstown-lv2,
  lsp-plugins,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpd-pocket-4-pipewire";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Manawyrm";
    repo = "gpd-pocket-4-pipewire";
    tag = finalAttrs.version;
    hash = "sha256-FNnEfY1a3CeFCH+dRwb7NyOeDPeHDnwacw/8jLawDK0=";
  };

  postPatch = ''
    substituteInPlace pipewire.conf.d/sink-gpd-pocket-4.conf \
      --replace-fail /usr/share/pipewire/pipewire.conf.d $out/share/pipewire/pipewire.conf.d
  '';

  installPhase = ''
    install -dDm0755 "$out/share/pipewire/pipewire.conf.d/"
    install -v -D -m0644 "pipewire.conf.d/gpd-pocket-4-mp-48k-l.wav" "$out/share/pipewire/pipewire.conf.d/gpd-pocket-4-mp-48k-l.wav"
    install -v -D -m0644 "pipewire.conf.d/gpd-pocket-4-mp-48k-r.wav" "$out/share/pipewire/pipewire.conf.d/gpd-pocket-4-mp-48k-r.wav"
    install -v -D -m0644 "pipewire.conf.d/sink-gpd-pocket-4.conf" "$out/share/pipewire/pipewire.conf.d/sink-gpd-pocket-4.conf"
  '';

  passthru.requiredLv2Packages = [
    bankstown-lv2
    lsp-plugins
  ];

  meta = {
    description = "Pipewire audio DSP for internal speakers of GPD Pocket 4";
    license = lib.licenses.mit;
    homepage = "https://github.com/Manawyrm/gpd-pocket-4-pipewire/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ marcel ];
  };
})

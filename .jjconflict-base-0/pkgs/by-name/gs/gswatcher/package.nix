{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  pkg-config,
  imagemagick,

  gtk4,
  libadwaita,
  libgee,
  lua5_4,
  geoip,
  geolite-legacy,

  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gswatcher";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "lxndr";
    repo = "gswatcher";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-U09vovOanYmDl5ymFC3bXU8pi8aUq2tPUE5AEoqmfpc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    wrapGAppsHook4
    desktop-file-utils
    # Not packaged yet, optional
    # appstream-util
    pkg-config
    imagemagick
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    lua5_4
    geoip
  ];

  postInstall = ''
    ln -s ${geolite-legacy}/share/GeoIP $out/share/GeoIP
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple game server monitor and administrative tool";
    homepage = "https://github.com/lxndr/gswatcher";
    license = with lib.licenses; [ agpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})

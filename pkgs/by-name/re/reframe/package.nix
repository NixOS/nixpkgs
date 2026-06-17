{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  cmake,
  systemd,
  glib,
  gtk4,
  libdrm,
  libepoxy,
  libxkbcommon,
  libvncserver,
  neatvnc,
  aml,
  pixman,
  zlib,
  ffmpeg,
  nix-update-script,

  withNeatVNC ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reframe";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "reframe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ZCLnmu5Idn4RsypJr+JNqIhT13/pq1Xi4wTidUgCqQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    systemd
    glib
    gtk4
    libdrm
    libepoxy
    libxkbcommon
    libvncserver
  ]
  ++ lib.optionals withNeatVNC [
    neatvnc
    aml
    pixman
    zlib
    ffmpeg
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  mesonFlags = [
    (lib.mesonOption "systemunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "sysusersdir" "${placeholder "out"}/lib/sysusers.d")
    (lib.mesonOption "tmpfilesdir" "${placeholder "out"}/lib/tmpfiles.d")
  ]
  ++ lib.optionals withNeatVNC [ (lib.mesonOption "neatvnc" "true") ];

  postPatch = ''
    chmod +x meson_post_install.sh
    patchShebangs meson_post_install.sh

    # Comment out all commands, all systemd reloading
    sed -i '1,2! s/^/# /' meson_post_install.sh
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://reframe.alynx.one/";
    description = "DRM/KMS based remote desktop for Linux that supports Wayland/NVIDIA/headless/login…";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bitbloxhub
    ];
    platforms = lib.platforms.linux;
  };
})

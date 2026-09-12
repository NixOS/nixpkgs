{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libgcrypt,
  readline,
  libbsd,
  fuse3,
  # Build the FUSE filesystem client (afp_client / mount_afpfs).
  withFuse ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk-client";
  version = "0.9.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Netatalk";
    repo = "netatalk-client";
    tag = finalAttrs.version;
    hash = "sha256-D4Urd+Hy0oiI5ETowWii7D+MHi7s6ltwZz26gCRWL1s=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    readline
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libbsd
  ++ lib.optional withFuse fuse3;

  mesonFlags = [
    (lib.mesonBool "enable-fuse" withFuse)
  ];

  meta = {
    description = "AFP (Apple Filing Protocol) client: afpcmd shell and FUSE filesystem";
    homepage = "https://github.com/Netatalk/netatalk-client";
    changelog = "https://github.com/Netatalk/netatalk-client/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    mainProgram = "afpcmd";
    maintainers = with lib.maintainers; [ nulleric ];
    platforms = lib.platforms.unix;
  };
})

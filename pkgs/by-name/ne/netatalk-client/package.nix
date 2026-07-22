{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  meson,
  ninja,
  pkg-config,
  libgcrypt,
  readline,
  libbsd,
  fuse3,
  avahi,
  # Build the FUSE filesystem client (afpfsd / mount_afpfs).
  withFuse ? stdenv.hostPlatform.isLinux,
  # Zeroconf service discovery for `afpc discover` and `afpcmd --browse`.
  withZeroconf ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk-client";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Netatalk";
    repo = "netatalk-client";
    tag = finalAttrs.version;
    hash = "sha256-8e2HQwBdAWqSMZxnA6kgFQmBAkI5NyWoWlolb9SzbCM=";
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
  ++ lib.optional withFuse fuse3
  ++ lib.optional withZeroconf avahi;

  mesonFlags = [
    (lib.mesonBool "enable-fuse" withFuse)
    # Zeroconf detection is "auto" and silently falls back to a stub backend,
    # so pin it rather than letting it depend on what leaks into the sandbox.
    (lib.mesonEnable "zeroconf" withZeroconf)
  ]
  ++ lib.optional withZeroconf (lib.mesonOption "zeroconf-backend" "avahi");

  passthru.tests = {
    inherit (nixosTests) netatalk;
  };

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

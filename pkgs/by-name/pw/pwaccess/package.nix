{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  linux-pam,
  systemdLibs,
  libxcrypt,
  libeconf,
  libselinux,
  selinuxSupport ? lib.meta.availableOn stdenv.hostPlatform libselinux,
  docbook-xsl-ns,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pwaccess";
  version = "0.2.0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "pwaccess";
    rev = "70d22e130e295ad407549d65aeafeb7d19a09c20";
    hash = "sha256-Ef4q/dFzZRqf35/Lxh2DWESDEDQ59Zq0bG602Y5jNrg=";
  };

  patches = [
    ./link-xcrypt.patch # pwupdd requires crypt.h, so explicitly link it
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    libxslt
    docbook-xsl-ns
  ];

  buildInputs = [
    linux-pam
    systemdLibs
    libxcrypt
    libeconf
  ]
  ++ lib.optional selinuxSupport libselinux;

  mesonFlags = [
    (lib.mesonEnable "selinux" selinuxSupport)
    (lib.mesonBool "b_lto" false)
  ];

  meta = {
    description = "The pwaccess package contains a library and a systemd service, which allows tools to read `/etc/shadow` entries without the need of having setuid/setgid bits set";
    homepage = "https://github.com/thkukuk/pwaccess";
    changelog = "https://github.com/thkukuk/pwaccess/blob/${finalAttrs.src.rev}/NEWS";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
      bsd2
    ];
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "pwaccess";
    platforms = lib.platforms.linux;
    # take precedence over shadow
    priority = -1;
  };
})

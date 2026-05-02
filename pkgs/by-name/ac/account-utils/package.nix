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
  libcap,
  libxcrypt,
  libeconf,
  libselinux,
  selinuxSupport ? lib.meta.availableOn stdenv.hostPlatform libselinux,
  docbook-xsl-ns,
  libxslt,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "account-utils";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "account-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PhyeZ4yioTMC7Q7wL5K5T74McKjmLqg8A5O5E3mhLgc=";
  };

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
    libcap
  ]
  ++ lib.optional selinuxSupport libselinux;

  mesonFlags = [
    (lib.mesonEnable "selinux" selinuxSupport)
    "-Dc_args=-ffat-lto-objects"
  ];

  passthru.tests = {
    inherit (nixosTests) login-nosuid;
  };

  meta = {
    description = "Services, utilities and PAM modules, which allow authentication and account management on systems with the NoNewPrivs flag set (no setuid/setgid binaries)";
    homepage = "https://github.com/thkukuk/account-utils";
    changelog = "https://github.com/thkukuk/account-utils/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      bsd2
    ];
    maintainers = with lib.maintainers; [ grimmauld ];
    platforms = lib.platforms.linux;
    # take precedence over shadow
    priority = -1;
  };
})

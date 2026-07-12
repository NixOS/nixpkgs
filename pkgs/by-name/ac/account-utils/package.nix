{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  linux-pam,
  systemdLibs,
  libcap,
  libxcrypt,
  libeconf,
  libselinux,
  docbook-xsl-ns,
  libxslt,
  nixosTests,
}:
let
  selinuxSupport = lib.meta.availableOn stdenv.hostPlatform libselinux;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "account-utils";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "account-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9l+y7FLb0IZXXp4RstlhNR6yA7b4b831obFuiVtO9+k=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    (lib.mesonOption "c_args" "-ffat-lto-objects")
  ];

  passthru.tests = {
    inherit (nixosTests) login-nosuid;
  };

  meta = {
    description = "Services, utilities and PAM modules, which allow authentication and account management on systems with the NoNewPrivs flag set (no setuid/setgid binaries)";
    homepage = "https://github.com/thkukuk/account-utils";
    changelog = "https://github.com/thkukuk/account-utils/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      AND [
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

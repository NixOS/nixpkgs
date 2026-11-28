{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_mountns";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "eduarrrd";
    repo = "pam_mountns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rCXS0vSYDNBm9eBIrb5PYUB1sdUSm/O8d4z3awV+fP8=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    pam
  ];

  doCheck = true;

  meta = {
    description = "PAM module to unconditionally create a mount namespace";
    homepage = "https://github.com/eduarrrd/pam_mountns/";
    changelog = "https://github.com/eduarrrd/pam_mountns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eduarrrd ];
  };
})

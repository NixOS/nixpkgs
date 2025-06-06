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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "eduarrrd";
    repo = "pam_mountns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B8wSV5CJOfXH5dNYEnTsxX9sN9vT8S72NFaXCGjKNZ4=";
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

  meta = {
    description = "PAM module to unconditionally create a mount namespace";
    homepage = "https://github.com/eduarrrd/pam_mountns/";
    changelog = "https://github.com/eduarrrd/pam_mountns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eduarrrd ];
  };
})

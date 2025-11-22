{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  qrtr,
  udev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rmtfs";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "rmtfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ehd8SbKNOpyVoF9oc7e5uYmJOHI+Q6woLyvwO8hhKEc=";
  };

  buildInputs = [
    qrtr
    udev
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qualcomm Remote Filesystem Service Implementation";
    homepage = "https://github.com/linux-msm/rmtfs";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "rmtfs";
  };
})

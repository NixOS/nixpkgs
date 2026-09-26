{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  systemd,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrtr";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qrtr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-plVPR3BKtMLSVgTK8TPFbt5vuo9ZovEGz6qJzUZ33G4=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [ systemd ];

  installFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "QMI IDL compiler";
    homepage = "https://github.com/linux-msm/qrtr";
    license = lib.licenses.bsd3;
    platforms = [ "aarch64-linux" ];
  };
})

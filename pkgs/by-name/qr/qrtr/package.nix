{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  cmake,
  pkg-config,
  systemd,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrtr";
  version = "0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qrtr";
    rev = "5923eea97377f4a3ed9121b358fd919e3659db7b";
    hash = "sha256-iHjF/2SQsvB/qC/UykNITH/apcYSVD+n4xA0S/rIfnM=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [ systemd ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "QMI IDL compiler";
    homepage = "https://github.com/linux-msm/qrtr";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
  };
})

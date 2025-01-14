{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  pkg-config,
  pandoc,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "stenc";
  version = "2.0.0_rc";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "scsitape";
    repo = "stenc";
    tag = version;
    sha256 = "sha256-oecFM/8q3m3dQpEn5LmqNhAoh/WR1B00NrPXSyJBRGs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
    installShellFiles
  ];

  doCheck = true;

  postInstall = ''
    installShellCompletion --bash bash-completion/stenc
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "SCSI Tape Encryption Manager";
    mainProgram = "stenc";
    homepage = "https://github.com/scsitape/stenc";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}

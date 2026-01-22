{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  pandoc,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "stenc";
  version = "2.0.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "scsitape";
    repo = "stenc";
    tag = version;
    sha256 = "sha256-M7b+T0mm2QTP1LqqjdKV/NWZ60DrueFEnN1unwCOeH4=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SCSI Tape Encryption Manager";
    mainProgram = "stenc";
    homepage = "https://github.com/scsitape/stenc";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}

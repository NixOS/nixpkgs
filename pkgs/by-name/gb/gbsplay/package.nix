{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  libpulseaudio,
  nas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gbsplay";
  version = "0.0.97";

  src = fetchFromGitHub {
    owner = "mmitch";
    repo = "gbsplay";
    rev = finalAttrs.version;
    hash = "sha256-O4t5OzXcrGoxzSXr0nzc01bItjcp1LvFeWnbdSUDwFU=";
  };

  configureFlags = [
    "--without-test" # See mmitch/gbsplay#62
    "--without-contrib"
  ];

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [
    libpulseaudio
    nas
  ];

  postInstall = ''
    installShellCompletion --bash --name gbsplay contrib/gbsplay.bashcompletion
  '';

  meta = {
    description = "Gameboy sound player";
    license = lib.licenses.gpl1Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "gbsplay";
  };
})

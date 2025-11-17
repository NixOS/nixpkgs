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
  version = "0.0.100";

  src = fetchFromGitHub {
    owner = "mmitch";
    repo = "gbsplay";
    rev = finalAttrs.version;
    hash = "sha256-vsfpBhx3bNs6hQDO+xAPWFsf8L8fMtfdU5XKjF/r6PA=";
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

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
  version = "0.0.103";

  src = fetchFromGitHub {
    owner = "mmitch";
    repo = "gbsplay";
    tag = finalAttrs.version;
    hash = "sha256-6SmwGuTnzn97ZNlTkkx4BfhFqurAS8Ugr1sk5khmhJM=";
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
    homepage = "https://github.com/mmitch/gbsplay";
    license = lib.licenses.gpl1Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "gbsplay";
  };
})

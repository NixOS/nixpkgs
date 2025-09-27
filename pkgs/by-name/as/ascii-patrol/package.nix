{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXi,
  libpulseaudio,
  curl,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii-patrol";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "msokalski";
    repo = "ascii-patrol";
    tag = finalAttrs.version;
    hash = "sha256-9LFq+Ti7cTe3sFwSejmFdisWISLt4A18UmOrlMpCkqA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-L/usr/X11/lib " ""
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    libX11
    libXi
    libpulseaudio
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 asciipat -t $out/bin
    install -Dm644 asciipat.psf -t $out/share/ascii-patrol

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/asciipat \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Moon Patrol inspired ASCII game";
    homepage = "https://ascii-patrol.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "asciipat";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})

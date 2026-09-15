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
  version = "1.7-unstable-2022-05-02";

  src = fetchFromGitHub {
    owner = "msokalski";
    repo = "ascii-patrol";
    rev = "bd3bd7c4eebddc90c3aa793b14b4a9ff11b2637c";
    hash = "sha256-0AuZE9s8BJ6QflF0vZ9BN707sT0k/mWc8QYlUAu2lII=";
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

  makeFlags = [
    "CXX=${stdenv.cc.targetPrefix}c++"
    "LD=${stdenv.cc.targetPrefix}c++"
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Moon Patrol inspired ASCII game";
    homepage = "https://ascii-patrol.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "asciipat";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})

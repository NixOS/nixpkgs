{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  ncurses,
  zlib,
}:

buildDubPackage rec {
  pname = "btdu";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "btdu";
    rev = "v${version}";
    hash = "sha256-ZZaBaDKfW52w2YWj34gXFruWNBNqjLUFsPCHmrCKT7I=";
  };

  dubLock = ./dub-lock.json;

  buildInputs = [
    ncurses
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 btdu -t $out/bin
    ./btdu --man "" > btdu.1
    install -Dm644 btdu.1 -t $out/share/man/man1
    runHook postInstall
  '';

  meta = {
    description = "Sampling disk usage profiler for btrfs";
    homepage = "https://github.com/CyberShadow/btdu";
    changelog = "https://github.com/CyberShadow/btdu/releases/tag/${src.rev}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      atila
      cybershadow
    ];
    mainProgram = "btdu";
  };
}

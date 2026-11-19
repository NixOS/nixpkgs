{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # fixes build with ldc 1.43
    (fetchpatch {
      name = "bump-ae.patch";
      url = "https://github.com/CyberShadow/btdu/commit/882b602b0243e36c9522ec282ce33a0c8b0b1c6a.patch";
      hash = "sha256-ZPmOM6+3A+x11ZQb732FyPFcg20PhMJhkYo+hwXz2rQ=";
    })
  ];

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
      cybershadow
    ];
    mainProgram = "btdu";
  };
}

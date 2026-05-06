{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "ascii-chess";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Parigyan";
    repo = "ASCII-Chess";
    rev = "f8cb9f102caa9188bbac511fe7c6df4f5759e821";
    hash = "sha256-arP93KVmheRD3vQshgXEbRdQBgzuOz4NCoqV9+SdKTg=";
  };

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    $CC $CPPFLAGS $CFLAGS -std=c99 -o ascii-chess src/chess3.c $LDFLAGS

    runHook postBuild
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    printf 'QUIT\nY\n' | ./ascii-chess >/dev/null

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ascii-chess -t "$out/bin"
    install -Dm644 README -t "$out/share/doc/ascii-chess"
    install -Dm644 COPYING -t "$out/share/licenses/ascii-chess"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal chess game written in C";
    homepage = "https://github.com/Parigyan/ASCII-Chess";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "ascii-chess";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}

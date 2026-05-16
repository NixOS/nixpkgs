{
  lib,
  gccStdenv,
  fetchFromGitHub,
  ncurses,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "programmer-calculator";
  version = "3.0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "alt-romes";
    repo = "programmer-calculator";
    rev = "153272c50b2491ddf25dfbfcf228a08a3b3ace69";
    hash = "sha256-24OYG3tVxcc/1i9HRrzW/jPY41KnKkugLziWnG1wQIw=";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall
    install -Dm 555 bin/pcalc -t "$out/bin"
    runHook postInstall
  '';

  meta = {
    description = "Terminal calculator for programmers";
    mainProgram = "pcalc";
    longDescription = ''
      Terminal calculator made for programmers working with multiple number
      representations, sizes, and overall close to the bits
    '';
    homepage = "https://alt-romes.github.io/programmer-calculator";
    changelog = "https://github.com/alt-romes/programmer-calculator/releases/tag/v${lib.versions.majorMinor finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ cjab ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "gmqcc";
  version = "0-unstable-2023-05-05";

  src = fetchFromGitHub {
    owner = "graphitemaster";
    repo = "gmqcc";
    rev = "2fe0af00e78d55edecd7ca7ee1808c4ea946b05f";
    hash = "sha256-AyuwsUIt+P/D4ABuIXGJxpp0TMAbnDg+R2iNMy6WjRw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 gmqcc $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://graphitemaster.github.io/gmqcc/";
    description = "Modern QuakeC compiler";
    mainProgram = "gmqcc";
    longDescription = ''
      For an enduring period of time the options for a decent compiler for
      the Quake C programming language were confined to a specific compiler
      known as QCC. Attempts were made to extend and improve upon the design
      of QCC, but many foreseen the consequences of building on a broken
      foundation. The solution was obvious, a new compiler; one born from
      the NIH realm of sarcastic wit.
      We welcome you. You won't find a better Quake C compiler.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ necrophcodr ];
    platforms = platforms.linux;
  };
}

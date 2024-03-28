{ lib
, stdenv
, fetchFromGitHub
, readline
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname   = "abc-verifier";
  version = "unstable-2024-03-04";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "0cd90d0d2c5338277d832a1d890bed286486bcf5";
    hash  = "sha256-1v/HOYF/ZdfR75eC3uYySKs2k6ZLCTUI0rtzPQs0hKQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  installPhase = ''
    runHook preInstall
    install -Dm755 'abc' "$out/bin/abc"
    runHook postInstall
  '';

  # needed by yosys
  passthru.rev = finalAttrs.src.rev;

  meta = with lib; {
    description = "A tool for squential logic synthesis and formal verification";
    homepage    = "https://people.eecs.berkeley.edu/~alanmi/abc";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice Luflosi ];
    mainProgram = "abc";
    platforms   = platforms.unix;
  };
})

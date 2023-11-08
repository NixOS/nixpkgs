{ lib
, stdenv
, fetchFromGitHub
, readline
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname   = "abc-verifier";
  version = "unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "daad9ede0137dc58487a0abc126253e671a85b14";
    hash  = "sha256-5XeFYvdqT08xduFUDC5yK1jEOV1fYzyQD7N9ZmG3mpQ=";
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

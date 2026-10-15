{
  lib,
  stdenv,
  fetchFromGitHub,
  libssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshping";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "spook";
    repo = "sshping";
    rev = "v${finalAttrs.version}";
    sha256 = "0p1fvpgrsy44yvj44xp9k9nf6z1fh0sqcjvy75pcb9f5icgms815";
  };

  buildInputs = [ libssh ];

  buildPhase = ''
    $CXX -Wall -I ext/ -o bin/sshping src/sshping.cxx -lssh
  '';

  installPhase = ''
    install -Dm755 bin/sshping $out/bin/sshping
  '';

  meta = {
    homepage = "https://github.com/spook/sshping";
    description = "Measure character-echo latency and bandwidth for an interactive ssh session";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jqueiroz ];
    mainProgram = "sshping";
  };
})

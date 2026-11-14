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
    hash = "sha256-JSBdH4vFpcVuOX5LhjWALnzjbJrpdkLk9oR4nd/dLlw=";
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

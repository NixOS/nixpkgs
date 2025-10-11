{
  buildGoModule,
  fetchgit,
  lib,
  ...
}:
buildGoModule {
  pname = "go-parallel";
  version = "0-unstable-2025-10-10";
  vendorHash = null;
  src = fetchgit {
    url = "https://git.voronind.com/voronind/par";
    rev = "0f02ae820de71ddff9e3b18930f446f9cc54324c";
    sha256 = "sha256-B5yW9gaBTDNI1M8F+iEkSZWJdorFE4yL3tIg3HIQVFc=";
  };
  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    install -Dm644 $src/completion.sh $out/share/bash-completion/completions/par
    mkdir -p $out/share/man/man1
    install -Dm644 $src/man.1 $out/share/man/man1/par.1
  '';

  meta = {
    description = "CLI shell parallelisation tool written in Go";
    homepage = "https://git.voronind.com/voronind/par";
    license = lib.licenses.mit;
    mainProgram = "par";
    maintainers = with lib.maintainers; [ voronind ];
  };
}

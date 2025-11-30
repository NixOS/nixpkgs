{
  buildGoModule,
  fetchgit,
  lib,
  ...
}:
buildGoModule {
  pname = "go-parallel";
  version = "0-unstable-2025-11-25";
  vendorHash = null;
  src = fetchgit {
    url = "https://git.voronind.com/voronind/par";
    rev = "4f8055ea07b31c79d791bbee86c030a587daaf5e";
    sha256 = "sha256-Lhs17Gfi7oU18TdB0Wl0tVdLQEKcJUFGJvIDKla4kAk=";
  };
  postInstall = ''
    install -D $src/completion.sh $out/share/bash-completion/completions/par
    install -D $src/man.1 $out/share/man/man1/par.1
  '';

  meta = {
    description = "CLI shell parallelisation tool written in Go";
    homepage = "https://git.voronind.com/voronind/par";
    license = lib.licenses.mit;
    mainProgram = "par";
    maintainers = with lib.maintainers; [ voronind ];
  };
}

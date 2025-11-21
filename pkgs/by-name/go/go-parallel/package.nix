{
  buildGoModule,
  fetchgit,
  lib,
  ...
}:
buildGoModule {
  pname = "go-parallel";
  version = "0-unstable-2025-11-09";
  vendorHash = null;
  src = fetchgit {
    url = "https://git.voronind.com/voronind/par";
    rev = "2001d77521747b5caf13123214786d14618ecf38";
    sha256 = "sha256-WLZyLdO7L0tzNIUGds+0QOeZrNtgFpAp801+N03+/Eg=";
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

{
  buildGoModule,
  fetchgit,
  lib,
  ...
}:
buildGoModule {
  pname = "go-parallel";
  version = "0-unstable-2025-12-06";
  vendorHash = null;
  src = fetchgit {
    url = "https://git.voronind.com/voronind/par";
    rev = "f7c6f2d381956ce51c33dccfb0e5755f15ad378b";
    sha256 = "mK6z/7v/6NgSisX+BFzuRMJVHRCdiOH/lVLaWd0oAxg=";
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

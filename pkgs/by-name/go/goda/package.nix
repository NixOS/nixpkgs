{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goda";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    hash = "sha256-g/sScj5VDQjpWmZN+1YqKJHixGwSBJi6v6YiGklSsjw=";
  };

  vendorHash = "sha256-Tkt01WSKMyShcw+/2iCh1ziHHhj24LnmfKY8KTDa+L8=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with maintainers; [ michaeladler ];
    license = licenses.mit;
    mainProgram = "goda";
  };
}

{
  buildGoModule,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

buildGoModule rec {
  pname = "jump";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "gsamokovarov";
    repo = "jump";
    rev = "v${version}";
    hash = "sha256-nlCuotEiAX2+xx7T8jWZo2p4LNLhWXDdcU6DxJprgx0=";
  };

  vendorHash = "sha256-nMUqZWdq//q/DNthvpKiYLq8f95O0QoItyX5w4vHzSA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage man/j.1 man/jump.1
  '';

  meta = with lib; {
    description = "Navigate directories faster by learning your habits";
    longDescription = ''
      Jump integrates with the shell and learns about your
      navigational habits by keeping track of the directories you visit. It
      strives to give you the best directory for the shortest search term.
    '';
    homepage = "https://github.com/gsamokovarov/jump";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "jump";
  };
}

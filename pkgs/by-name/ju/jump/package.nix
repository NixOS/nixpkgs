{
  buildGoModule,
  fetchFromGitHub,
  lib,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "jump";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "gsamokovarov";
    repo = "jump";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/vMQIbpfnEzBhyCUgSd4XpeC9cEX/+AYIRDTOqgmCec=";
  };

  vendorHash = "sha256-nMUqZWdq//q/DNthvpKiYLq8f95O0QoItyX5w4vHzSA=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage man/j.1 man/jump.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jump \
       --bash <($out/bin/jump shell bash) \
       --fish <($out/bin/jump shell fish) \
       --zsh <($out/bin/jump shell zsh)
  '';

  meta = {
    description = "Navigate directories faster by learning your habits";
    longDescription = ''
      Jump integrates with the shell and learns about your
      navigational habits by keeping track of the directories you visit. It
      strives to give you the best directory for the shortest search term.
    '';
    homepage = "https://github.com/gsamokovarov/jump";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jump";
  };
})

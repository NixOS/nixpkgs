{
  boring,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "boring";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = finalAttrs.version;
    hash = "sha256-N0GVXtw6Gp6iHKBD2Lk6FX8XaUnkPgZduPaczYdApAs=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-j8A0F+o3EnzJdge+T/gHAwRGwzC86oD6ddZejUs/C7o=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd boring      \
      --bash <($out/bin/boring --shell bash) \
      --fish <($out/bin/boring --shell fish) \
      --zsh  <($out/bin/boring --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = boring;
    command = "boring version";
    version = "boring ${finalAttrs.version}";
  };

  meta = {
    description = "SSH tunnel manager";
    homepage = "https://github.com/alebeck/boring";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
    mainProgram = "boring";
  };
})

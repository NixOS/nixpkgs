{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "miniflux";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = finalAttrs.version;
    hash = "sha256-u3YnABf+ik7q29JtOSlK+UlInLRq5mMlH7vIDpxOOvk=";
  };

  vendorHash = "sha256-JBT3BUFbPrSpkeZUoGiJJaeiSyXu8y+xcHWPNpxo3cU=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestClient" ]; # skip client tests as they require network access

  ldflags = [
    "-s"
    "-w"
    "-X miniflux.app/v2/internal/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage miniflux.1
  '';

  passthru = {
    tests = nixosTests.miniflux;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    changelog = "https://miniflux.app/releases/${finalAttrs.version}.html";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rvolosatovs
      benpye
      emilylange
      adamcstephens
    ];
    mainProgram = "miniflux";
  };
})

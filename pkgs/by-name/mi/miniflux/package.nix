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
<<<<<<< HEAD
  version = "2.2.15";
=======
  version = "2.2.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-19i+TeBcPnI1Gfpf81gHE9sLvytsS4x1A5XU8oD7YIU=";
  };

  vendorHash = "sha256-XrTmXAUABlTQaA3Z0vU0HQW5Q1e/Yg6yq690oZH8M+A=";
=======
    hash = "sha256-x6I5PMlQtsjvFtEyoaKKE6if3I0IBIyps4kPQL4c8aw=";
  };

  vendorHash = "sha256-X/6YvAhIHSOS3qaoR6/pa2b7EziZzx8B+CbYrJ9/mcM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Minimalist and opinionated feed reader";
    changelog = "https://miniflux.app/releases/${finalAttrs.version}.html";
    homepage = "https://miniflux.app/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    changelog = "https://miniflux.app/releases/${finalAttrs.version}.html";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      rvolosatovs
      benpye
      emilylange
      adamcstephens
    ];
    mainProgram = "miniflux";
  };
})

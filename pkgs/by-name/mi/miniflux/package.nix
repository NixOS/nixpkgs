{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "miniflux";
  version = "2.2.18";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = finalAttrs.version;
    hash = "sha256-r5MFYdWV17u2ogxN01w9FpP/ErgqQmTEl5Nizg9FzCY=";
  };

  vendorHash = "sha256-F1FbenWzokNnF6xiZeqpu5HWs1PZo0WtlZX/ePTvBTE=";

  nativeBuildInputs = [ installShellFiles ];

  # skip tests that require network access
  checkFlags = [ "-skip=TestResolvesToPrivateIP" ];

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

  meta = {
    description = "Minimalist and opinionated feed reader";
    changelog = "https://miniflux.app/releases/${finalAttrs.version}.html";
    homepage = "https://miniflux.app/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rvolosatovs
      benpye
      emilylange
      adamcstephens
    ];
    mainProgram = "miniflux";
  };
})

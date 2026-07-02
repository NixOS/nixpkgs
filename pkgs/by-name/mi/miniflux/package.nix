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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = finalAttrs.version;
    hash = "sha256-AF5wiFLXtyf0ZxfVu0zdXcVExm7Zoh/wYS9FuSjfipk=";
  };

  vendorHash = "sha256-9qHe21/Qu2OInjcn4gQOh3LEQ1iqT6rzm8agj+YUD68=";

  nativeBuildInputs = [ installShellFiles ];

  # skip tests that require network access
  checkFlags = [ "-skip=TestResolvesToPrivateIP" ];

  ldflags = [
    "-s"
    "-w"
    "-X miniflux.app/v2/internal/version.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

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

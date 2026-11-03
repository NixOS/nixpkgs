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
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    tag = finalAttrs.version;
    hash = "sha256-qia5Xnmku0w6o2UVfxKvAHicF/1pAKcXIfQf8A/wmVM=";
  };

  vendorHash = "sha256-st4lJ12JwHv1AwxNEEzus+8GkDn5C3bmBJjJtzVt1v0=";

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

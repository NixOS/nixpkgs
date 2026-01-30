{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-httpbin";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "mccutchen";
    repo = "go-httpbin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FXD5XgvdQ5b6AcDC2VJPSDJXjb6RwOskPNtBV4fy6Pc=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # tests are flaky
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/go-httpbin --help &> /dev/null
    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) go-httpbin; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reasonably complete and well-tested golang port of httpbin, with zero dependencies outside the go stdlib";
    homepage = "https://github.com/mccutchen/go-httpbin";
    changelog = "https://github.com/mccutchen/go-httpbin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "go-httpbin";
  };
})

{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nix-update-script }:

buildGoModule rec {
  pname = "globalping-cli";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "jsdelivr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-txc0q/up4/KzVXOOzpBC8Onh7y2jg3hwqjHpUvt68TM=";
  };

  vendorHash = "sha256-V6DwV2KukFfFK0PK9MacoHH0sB5qNV315jn0T+4rhfA=";

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  checkFlags =
    let
      skippedTests = [
        # Skip tests that require network access
        "Test_Authorize"
        "Test_TokenIntrospection"
        "Test_Logout"
        "Test_RevokeToken"
        "Test_Limits"
        "Test_CreateMeasurement"
        "Test_GetMeasurement"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "|^" skippedTests}" ];

  postInstall = ''
    mv $out/bin/${pname} $out/bin/globalping
    installShellCompletion --cmd globalping \
      --bash <($out/bin/globalping completion bash) \
      --fish <($out/bin/globalping completion fish) \
      --zsh <($out/bin/globalping completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Simple CLI tool to run networking commands remotely from hundreds of globally distributed servers";
    homepage = "https://www.jsdelivr.com/globalping/cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "globalping";
  };
}

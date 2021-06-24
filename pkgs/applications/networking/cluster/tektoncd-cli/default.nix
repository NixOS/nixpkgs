{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "tektoncd-cli";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "tektoncd";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-7VG9OFt1yVt4st8EM1aiRqLCHwjSqib28GoamoJHHnM=";
  };

  vendorSha256 = null;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/tektoncd/cli/pkg/cmd/version.clientVersion=${version}")
  '';

  nativeBuildInputs = [ installShellFiles ];

  # third_party/VENDOR-LICENSE breaks build/check as go files are still included
  # docs is a tool for generating docs
  excludedPackages = "\\(third_party\\|cmd/docs\\)";

  preCheck = ''
    # Change the golden files to match our desired version
    sed -i "s/dev/${version}/" pkg/cmd/version/testdata/TestGetVersions-*.golden
  '';

  postInstall = ''
    installManPage docs/man/man1/*

    installShellCompletion --cmd tkn \
      --bash <($out/bin/tkn completion bash) \
      --fish <($out/bin/tkn completion fish) \
      --zsh <($out/bin/tkn completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/tkn --help
    $out/bin/tkn version | grep "Client version: ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://tekton.dev";
    changelog = "https://github.com/tektoncd/cli/releases/tag/v${version}";
    description = "Provides a CLI for interacting with Tekton";
    longDescription = ''
      The Tekton Pipelines cli project provides a CLI for interacting with Tekton!
      For your convenience, it is recommended that you install the Tekton CLI, tkn, together with the core component of Tekton, Tekton Pipelines.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk mstrangfeld vdemeester ];
  };
}

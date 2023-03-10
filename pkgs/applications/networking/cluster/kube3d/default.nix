{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, k3sVersion ? null
}:

let
  hasVPrefix = ver: (builtins.elemAt (lib.stringToCharacters ver) 0) == "v";
  k3sVersionSet =
    if k3sVersion != null then
      if hasVPrefix k3sVersion then throw "k3sVersion should not have a v prefix" else true
    else
      false;
in
buildGoModule rec {
  pname = "kube3d";
  version = "5.4.4";

  src = fetchFromGitHub {
    owner = "k3d-io";
    repo = "k3d";
    rev = "v${version}";
    sha256 = "sha256-3J25Aj/otKDCWJ+YqAsoJogU2vckZMy7fsS8XR2EMgE=";
  };
  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "tools" "docgen" ];

  ldflags =
    let t = "github.com/k3d-io/k3d/v5/version"; in
    [ "-s" "-w" "-X ${t}.Version=v${version}" ] ++ lib.optionals k3sVersionSet [ "-X ${t}.K3sVersion=v${k3sVersion}" ];

   preCheck = ''
    # skip test that uses networking
    substituteInPlace version/version_test.go \
      --replace "TestGetK3sVersion" "SkipGetK3sVersion"
  '';

  postInstall = ''
    installShellCompletion --cmd k3d \
      --bash <($out/bin/k3d completion bash) \
      --fish <($out/bin/k3d completion fish) \
      --zsh <($out/bin/k3d completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/k3d --help
    $out/bin/k3d --version | grep -e "k3d version v${version}" ${lib.optionalString k3sVersionSet "-e \"k3s version v${k3sVersion}\""}
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/k3d-io/k3d/";
    changelog = "https://github.com/k3d-io/k3d/blob/v${version}/CHANGELOG.md";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container - k3d";
    longDescription = ''
      k3s is the lightweight Kubernetes distribution by Rancher: rancher/k3s

      k3d creates containerized k3s clusters. This means, that you can spin up a
      multi-node k3s cluster on a single machine using docker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle jk ricochet ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "k3d";
  };
}

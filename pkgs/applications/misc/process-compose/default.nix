{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let config-module = "github.com/f1bonacc1/process-compose/src/config";
in
buildGoModule rec {
  pname = "process-compose";
  version = "0.51.4";

  src = fetchFromGitHub {
    owner = "F1bonacc1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eR8uYeScV6bxntc2bEwJC/VSH1bXendJ1FNJB0bC2i0=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X ${config-module}.Commit=$(cat COMMIT)"
    ldflags+=" -X ${config-module}.Date=$(cat SOURCE_DATE_EPOCH)"
  '';

  ldflags = [
    "-X ${config-module}.Version=v${version}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-dlTqBKyI2t3twxQ+mnn+LTWzM2+CnEa4X0K2yDAZsQA=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/{src,process-compose}

    installShellCompletion --cmd process-compose \
      --bash <($out/bin/process-compose completion bash) \
      --zsh <($out/bin/process-compose completion zsh) \
      --fish <($out/bin/process-compose completion fish)
  '';

  meta = with lib; {
    description = "A simple and flexible scheduler and orchestrator to manage non-containerized applications";
    homepage = "https://github.com/F1bonacc1/process-compose";
    changelog = "https://github.com/F1bonacc1/process-compose/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ thenonameguy ];
  };
}

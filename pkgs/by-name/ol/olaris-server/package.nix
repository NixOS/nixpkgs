{
  buildGoModule,
  fetchFromGitLab,
  fetchzip,
  ffmpeg,
  installShellFiles,
  lib,
  makeWrapper,
}:

buildGoModule rec {
  pname = "olaris-server";
  version = "unstable-2025-12-12";

  src = fetchFromGitLab {
    owner = "olaris";
    repo = "olaris-server";
    rev = "d4b240e775225cb96ca1634f60faba8e4960ce67";
    hash = "sha256-S3Qmoyha9ab/nRJbuPz2Rf8orZF43UFC+PFsPUcNoUY=";
  };

  preBuild =
    let
      olaris-react = fetchzip {
        url = "https://gitlab.com/api/v4/projects/olaris%2Folaris-react/jobs/artifacts/v${version}/download?job=build";
        extension = "zip";
        hash = "sha256-MkxBf/mGvtiOu0e79bMpd9Z/D0eOxhzPE+bKic//viM=";
      };
    in
    ''
      # cannot build olaris-react https://github.com/NixOS/nixpkgs/issues/203708
      cp -r ${olaris-react} react/build
      make generate
    '';

  ldflags = [
    "-s"
    "-w"
    "-X gitlab.com/olaris/olaris-server/helpers.Version=${version}"
  ];

  vendorHash = "sha256-z97hvJCq7ocWpoViq8+ZHtYp0AUGIEZxq0FPRnEYKSw=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd olaris-server \
      --bash <($out/bin/olaris-server completion bash) \
      --fish <($out/bin/olaris-server completion fish) \
      --zsh <($out/bin/olaris-server completion zsh)
      wrapProgram $out/bin/olaris-server --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    description = "Media manager and transcoding server";
    homepage = "https://gitlab.com/olaris/olaris-server";
    changelog = "https://gitlab.com/olaris/olaris-server/-/releases/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ urandom ];
  };
}

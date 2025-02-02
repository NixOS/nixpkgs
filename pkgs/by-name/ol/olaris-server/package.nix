{ buildGoModule
, fetchFromGitLab
, fetchzip
, ffmpeg
, installShellFiles
, lib
, makeWrapper
}:

buildGoModule rec {
  pname = "olaris-server";
  version = "unstable-2022-06-11";

  src = fetchFromGitLab {
    owner = "olaris";
    repo = pname;
    rev = "bdb2aeb1595c941210249164a97c12404c1ae0d8";
    hash = "sha256-Uhnh6GC85ORKnfHeYNtbSA40osuscxXDF5/kXJrF2Cs=";
  };

  preBuild = let
    olaris-react = fetchzip {
      url = "https://gitlab.com/api/v4/projects/olaris%2Folaris-react/jobs/artifacts/v${version}/download?job=build";
      extension = "zip";
      hash = "sha256-MkxBf/mGvtiOu0e79bMpd9Z/D0eOxhzPE+bKic//viM=";
    };
  in ''
    # cannot build olaris-react https://github.com/NixOS/nixpkgs/issues/203708
    cp -r ${olaris-react} react/build
    make generate
  '';

  ldflags = [
    "-s"
    "-w"
    "-X gitlab.com/olaris/olaris-server/helpers.Version=${version}"
  ];

  vendorHash = "sha256-bw8zvDGFBci9bELsxAD0otpNocBnO8aAcgyohLZ3Mv0=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd olaris-server \
      --bash <($out/bin/olaris-server completion bash) \
      --fish <($out/bin/olaris-server completion fish) \
      --zsh <($out/bin/olaris-server completion zsh)
      wrapProgram $out/bin/olaris-server --prefix PATH : ${lib.makeBinPath [ffmpeg]}
  '';

  meta = with lib; {
    description = "Media manager and transcoding server";
    homepage = "https://gitlab.com/olaris/olaris-server";
    changelog = "https://gitlab.com/olaris/olaris-server/-/releases/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}

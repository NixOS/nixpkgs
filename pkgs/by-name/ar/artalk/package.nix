{
  lib,
  buildGoModule,
  fetchFromGitHub,
  artalk,
  fetchurl,
  installShellFiles,
  stdenv,
  testers,
  nixosTests,
}:
buildGoModule rec {
  pname = "artalk";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-5tUUlkGeT4kY/81EQ29M6z+JnBT4YCa8gecbV9WMuDo=";
  };
  web = fetchurl {
    url = "https://github.com/${src.owner}/${src.repo}/releases/download/v${version}/artalk_ui.tar.gz";
    hash = "sha256-Cx3fDpnl52kwILzH9BBLfsWe5qEbIl/ecJd1wJEB/Hc=";
  };

  CGO_ENABLED = 1;

  vendorHash = "sha256-edqmv/Q99pgnScJqCmLwjHd7uKMNPGfCSujNTUQtpLc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ArtalkJS/Artalk/internal/config.Version=${version}"
    "-X github.com/ArtalkJS/Artalk/internal/config.CommitHash=${version}"
  ];

  preBuild = ''
    tar -xzf ${web}
    cp -r ./artalk_ui/* ./public
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    ''
      # work around case insensitive file systems
      mv $out/bin/Artalk $out/bin/artalk.tmp
      mv $out/bin/artalk.tmp $out/bin/artalk
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd artalk \
        --bash <($out/bin/artalk completion bash) \
        --fish <($out/bin/artalk completion fish) \
        --zsh <($out/bin/artalk completion zsh)
    '';

  passthru.tests = {
    version = testers.testVersion { package = artalk; };
    inherit (nixosTests) artalk;
  };

  meta = {
    description = "Self-hosted comment system";
    homepage = "https://github.com/ArtalkJS/Artalk";
    changelog = "https://github.com/ArtalkJS/Artalk/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "artalk";
  };
}

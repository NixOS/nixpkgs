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
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-fOuZiFomXGvRUXkpEM3BpJyMOtSm6/RHd0a7dPOsoT4=";
  };
  web = fetchurl {
    url = "https://github.com/${src.owner}/${src.repo}/releases/download/v${version}/artalk_ui.tar.gz";
    hash = "sha256-3Rg5mCFigLkZ+X8Fxe6A16THd9j6hcTYMEAKU1SrLMw=";
  };

  CGO_ENABLED = 1;

  vendorHash = "sha256-Hm388ub/ja3PuSRqPkr6A+pgKUQ+czMj1WKU8W8H5wI=";

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

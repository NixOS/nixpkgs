{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
, installShellFiles
}:

let
  version = "0.2.0";
  gitSrc = fetchFromGitHub {
    owner = "glasskube";
    repo = "glasskube";
    rev = "refs/tags/v${version}";
    hash = "sha256-r14gYgrenUk3OFUEab4QlwmwUeEwqocJJ3Vje9wRdBA=";
  };
  web-bundle = buildNpmPackage rec {
    inherit version;
    pname = "glasskube-web-bundle";

    src = gitSrc;

    npmDepsHash = "sha256-WKwEAVMG6r/ZFmxgLR+zJCW8F2DOHxpWDYqhX/vcdrs=";

    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv internal/web/root/static/bundle $out

      runHook postInstall
    '';
  };

in buildGoModule rec {
  inherit version;
  pname = "glasskube";

  src = gitSrc;

  vendorHash = "sha256-sj9TEAWhExwaaKlMJ10U7m3/xbUNl0dVZwrCb2TTu4o=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glasskube/glasskube/internal/config.Version=${version}"
    "-X github.com/glasskube/glasskube/internal/config.Commit=${src.rev}"
  ];

  subPackages = [ "cmd/${pname}" "cmd/package-operator" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    cp -r ${web-bundle}/bundle internal/web/root/static/bundle
  '';

  postInstall = ''
    # Completions
    installShellCompletion --cmd glasskube \
      --bash <($out/bin/glasskube completion bash) \
      --fish <($out/bin/glasskube completion fish) \
      --zsh <($out/bin/glasskube completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description =
      "The missing Package Manager for Kubernetes featuring a GUI and a CLI";
    homepage = "https://github.com/glasskube/glasskube";
    changelog =
      "https://github.com/glasskube/glasskube/releases/tag/v${version}";
    maintainers = with maintainers; [ jakuzure ];
    license = licenses.asl20;
    mainProgram = "glasskube";
  };
}

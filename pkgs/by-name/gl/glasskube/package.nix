{ lib
, buildGo123Module
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
, installShellFiles
, versionCheckHook
}:

let
  version = "0.25.0";
  gitSrc = fetchFromGitHub {
    owner = "glasskube";
    repo = "glasskube";
    rev = "refs/tags/v${version}";
    hash = "sha256-456kMO7KappYI2FuHA8g+uhkJNCGCxb/9zmleZqu6SQ=";
  };
  web-bundle = buildNpmPackage rec {
    inherit version;
    pname = "glasskube-web-bundle";

    src = gitSrc;

    npmDepsHash = "sha256-XKPFT8eyZmDhNbuCpTzGYeg5QdhgpVhHkj8AGSlh6WU=";

    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv internal/web/root/static/bundle $out

      runHook postInstall
    '';
  };

in buildGo123Module rec {
  inherit version;
  pname = "glasskube";

  src = gitSrc;

  vendorHash = "sha256-oly6SLgXVyvKQQuPrb76LYngoDPNLjTAs4gWCT3/kew=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/glasskube/glasskube/internal/config.Version=${version}"
    "-X github.com/glasskube/glasskube/internal/config.Commit=${src.rev}"
  ];

  subPackages = [ "cmd/glasskube" "cmd/package-operator" ];

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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

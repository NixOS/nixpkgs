{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  coreutils,
}:

buildGoModule rec {
  pname = "devdash";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Phantas0s";
    repo = "devdash";
    rev = "refs/tags/v${version}";
    hash = "sha256-RUPpgMVl9Cm8uhztdfKnuQ6KdMn9m9PewlT59NnTSiY=";
  };

  vendorHash = "sha256-xuc8rAkyCInNFxs5itwabqBe4CPg/sAuhcTJsapx7Q8=";

  ldflags = [
    "-s -w"
    "-X github.com/Phantas0s/devdash/cmd.current=${version}"
    "-X github.com/Phantas0s/devdash/cmd.buildDate=1970-01-01-00:00:01"
  ];

  patchPhase = ''
    runHook prePatch

    shopt -s globstar
    substituteInPlace **/*.go --replace '"/bin/' '"/usr/bin/env '
    shopt -u globstar

    runHook postPatch
  '';

  runtimeDependencies = [
    coreutils
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Highly configurable terminal dashboard for developers and creators";
    homepage = "https://github.com/Phantas0s/devdash";
    changelog = "https://github.com/Phantas0s/devdash/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ h7x4 ];
    license = lib.licenses.asl20;
    mainProgram = "devdash";
  };
}

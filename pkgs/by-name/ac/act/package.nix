{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
  act,
}:

let
<<<<<<< HEAD
  version = "0.2.83";
=======
  version = "0.2.82";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3z6+WcfxHyPTgsOHs2NPd4x7buMBr3jCA2zqd6kBb6k=";
=======
    hash = "sha256-NIslUM0kvgS4szejCngb1zJ+cjlJ970XkeegDjyOYIs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-EQgW+I0HjJhKioN0Moke9i+OggyJOSOHyatYnED4NX4=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = act;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
=======
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kashw2
    ];
  };
}

{
  lib,
  fetchpatch,
  buildGo123Module,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "git-spice";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    rev = "refs/tags/v${version}";
    hash = "sha256-ftNLe/3akvk6nUrseBqpbJQSiUPEJO6cTEc7uEBKX3k=";
  };

  vendorHash = "sha256-f7bjlTVwCFoQrgbeyAvsVAS6vy5uE/AvMGKEutE1lfs=";

  # Fixes flaky test. Remove next release.
  patches = [
    (fetchpatch {
      url = "https://github.com/abhinav/git-spice/commit/92c28474bab81881443129e4a8e9bfc3f1564931.patch";
      hash = "sha256-6v++jG7Wm6awqHRiNzwjX25BB8X9yGYhSzcUDNQKJ7k=";
    })
  ];

  subPackages = [ "." ];

  nativeCheckInputs = [ git ];

  buildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage stacked Git branches";
    homepage = "https://abhinav.github.io/git-spice/";
    changelog = "https://github.com/abhinav/git-spice/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "gs";
  };
}

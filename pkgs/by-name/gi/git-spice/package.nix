{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

buildGoModule rec {
  pname = "git-spice";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    rev = "refs/tags/v${version}";
    hash = "sha256-D+kwH7fBRvi+H0/L7Gezn1FMBk3AkL9MbLULAwvrzrg=";
  };

  vendorHash = "sha256-24jtlvp8xSMzNejyzqt+MiQHRKprps132Q+rP9wlA30=";

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

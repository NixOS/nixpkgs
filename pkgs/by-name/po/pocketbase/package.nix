{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.24.4";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-wUHPp48kI+9ij/eVkgWKTxwGNOhrUBZXGhKd3z6YHZU=";
  };

  vendorHash = "sha256-Elli5NSddF2tgKiJg8CH8KtR3mP+OfaIMRc15oKYNh8=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  env.CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [
      dit7ya
      thilobillerbeck
    ];
    mainProgram = "pocketbase";
  };
}

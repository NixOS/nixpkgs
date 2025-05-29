{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-R8sXa3Cs7GFRAs8/+wAoWteFYBUVsgVA+eJDKACb0k8=";
  };

  vendorHash = "sha256-bTXxhHibKiu+btHhnktTpNycMJSzGekRJ+w9b1IwAQs=";

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

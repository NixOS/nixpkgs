{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.25.9";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-8DObORJKpK7azcZLLHaToajPfO7aYsv4pIsmH8bl518=";
  };

  vendorHash = "sha256-Th71aNCzWwOfYvVCHFRhppnGKXtJqfHLzl23FuT2pK4=";

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

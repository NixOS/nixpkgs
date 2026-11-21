{
  lib,
  buildGoModule,
  fetchgit,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pocketbase";
  version = "0.42.3";

  src = fetchgit {
    url = "https://ganigeorgiev.com/git/pocketbase/pocketbase";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2JAp5SXRjQf5ERYwtKUOqVHtrwIaNu7+0TNe0PLc/TI=";
  };

  vendorHash = "sha256-kpabcSXJQTAMzGYqVrQZIlrC44WUtuoKHGnLjShkRTQ=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  env.CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://ganigeorgiev.com/pocketbase/pocketbase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thilobillerbeck
    ];
    mainProgram = "pocketbase";
  };
})

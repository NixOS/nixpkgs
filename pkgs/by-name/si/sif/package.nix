{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-02-23";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "fef7806ac22938a480cc35e429f6862b758928a5";
    hash = "sha256-mLz6CXpxbo7zQTgOxJJ7tvvCi/X2LWS+87iGDKhXeo4=";
  };

  vendorHash = "sha256-svuWF0mUfUBKpigY34A7Iio3d4LIR1wj2ks4KGUv0wE=";

  subPackages = [ "cmd/sif" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # network-dependent tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "sif";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pocketbase";
<<<<<<< HEAD
  version = "0.35.0";
=======
  version = "0.34.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rvEchQfJr4frFOmuKPRcV2dwl97u36tgayJvbm3X7ks=";
  };

  vendorHash = "sha256-dNkpHGMtnR0sL9+Fl+NOfyQLJ9AXxgsnV5X9ieAVcao=";
=======
    hash = "sha256-kMj/JXPBsu30K0P7rCnAqb8xBTmBctGvVucDVwgKjjY=";
  };

  vendorHash = "sha256-Ri9fgCMfWqc/TBteSm8gAUkjserhfg4ZZ8CpofQJOdI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      dit7ya
      thilobillerbeck
    ];
    mainProgram = "pocketbase";
  };
}

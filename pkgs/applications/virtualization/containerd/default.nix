{ lib
, fetchFromGitHub
, buildGoModule
, btrfs-progs
, go-md2man
, installShellFiles
, util-linux
, nixosTests
, kubernetes
}:

buildGoModule rec {
  pname = "containerd";
<<<<<<< HEAD
  version = "1.7.5";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-g+1JfXO1k0ijPpVTo+WxmXro4p4MbRCIZdgtgy58M60=";
=======
    hash = "sha256-WwedtcsrDQwMQcKFO5nnPiHyGJpl5hXZlmpbBe1/ftY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  nativeBuildInputs = [ go-md2man installShellFiles util-linux ];

  buildInputs = [ btrfs-progs ];

  BUILDTAGS = lib.optionals (btrfs-progs == null) [ "no_btrfs" ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make binaries "VERSION=v${version}" "REVISION=${src.rev}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 bin/* -t $out/bin
    installShellCompletion --bash contrib/autocomplete/ctr
    installShellCompletion --zsh --name _ctr contrib/autocomplete/zsh_autocomplete
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) docker; } // kubernetes.tests;

  meta = with lib; {
    changelog = "https://github.com/containerd/containerd/releases/tag/${src.rev}";
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ offline vdemeester endocrimes ];
=======
    maintainers = with maintainers; [ offline vdemeester endocrimes zowoq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}

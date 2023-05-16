{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles, stdenv }:

let
<<<<<<< HEAD
  version = "2.1.0";
  sha256 = "08g9awlgij8privpmzmrg63aygcjqmycr981ak0lkbx5chynlnmn";
  manifestsSha256 = "06iqmc5rg9l7zwcyg66fvy6h1g4bg1mr496n17piapjiqiv3j3q4";
=======
  version = "2.0.0-rc.2";
  sha256 = "0b7ls2amzmfjy6hw6kwcmhjj2wdara4igwk2wby6ah2yj5nipb45";
  manifestsSha256 = "1xj0g65czl20j8axi6n07sm9ijzmr7vhczfdpx4xqx6m3bl9vqxs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  manifests = fetchzip {
    url =
      "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = manifestsSha256;
    stripRoot = false;
  };

in buildGoModule rec {
  pname = "fluxcd";
  inherit version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    inherit sha256;
  };

<<<<<<< HEAD
  vendorHash = "sha256-RVHDiJS1MhskVorS/SNZlXWP/oc8OXjUjApeanBkIWQ=";
=======
  vendorSha256 = "sha256-HWKpaMHBX8wvG2aDX/U9lI9KNMcbBNxxG3yigYa+VX8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests

    # disable tests that require network access
    rm source/cmd/flux/create_secret_git_test.go
  '';

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  subPackages = [ "cmd/flux" ];

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/flux completion $shell > flux.$shell
      installShellCompletion flux.$shell
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description =
      "Open and extensible continuous delivery solution for Kubernetes";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 jlesquembre ];
    mainProgram = "flux";
  };
}

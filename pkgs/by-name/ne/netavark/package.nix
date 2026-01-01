{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  mandown,
  protobuf,
  nixosTests,
  go-md2man,
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
<<<<<<< HEAD
  version = "1.17.1";
=======
  version = "1.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KLN1Y2C43dTZlm1VNZq49/zQY55iAPf5V7KK5zjC2dw=";
  };

  cargoHash = "sha256-Ac8/0MgvDZ3djUlKOv3yT3aCPkxbNPnFM8ZId6yN354=";
=======
    hash = "sha256-Co7Wt6eUwbDVd+MljXh+kJ1Op8ekGzYxWA4j8EWa0jk=";
  };

  cargoHash = "sha256-FBvD7EY+NryetZmJSAMZdikDi5N5kLWHL8gzd0rGnj8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    installShellFiles
    mandown
    protobuf
    go-md2man
  ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

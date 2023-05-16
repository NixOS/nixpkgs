<<<<<<< HEAD
{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.27.5+rke2r1";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.27.1+rke2r1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LKVz/oKt3WDf84KEEj4dRyjkRWZIWbOnEgG03EHvfGQ=";
  };

  vendorHash = "sha256-Ck3/sMvCLoXKtOIhn0uE8hHdTlPFjIT04l3zoZQNKPs=";

  postPatch = ''
    # Patch the build scripts so they work in the Nix build environment.
    patchShebangs ./scripts

    # Disable the static build as it breaks.
    sed -e 's/STATIC_FLAGS=.*/STATIC_FLAGS=/g' -i scripts/build-binary
  '';

  buildPhase = ''
    DRONE_TAG="v${version}" ./scripts/build-binary
  '';

  installPhase = ''
    install -D ./bin/rke2 $out/bin/rke2
  '';
=======
    hash = "sha256-MPhE4dkFDLMG/Zxn9UqUMmbV95wfNDJU9C5CT8Ap5iA=";
  };

  vendorHash = "sha256-STpM7GxLdEhe7tfa6n6jyUSQsE9D91pCBvw1n7Q9qMc=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/k3s-io/k3s/pkg/version.Version=v${version}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ zimbatm zygot ];
    mainProgram = "rke2";
    broken = stdenv.isDarwin;
=======
    maintainers = with maintainers; [ zygot ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

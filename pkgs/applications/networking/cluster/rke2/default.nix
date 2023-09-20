{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.27.5+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm zygot ];
    mainProgram = "rke2";
    broken = stdenv.isDarwin;
  };
}

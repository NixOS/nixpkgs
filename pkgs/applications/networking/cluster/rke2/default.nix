{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rke2";
  version = "1.29.0+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E59GUcbnbvsGZYn87RGNrGTVUsydKsjL+C5h15q74p0=";
  };

  vendorHash = "sha256-Og0CqxNnhRN6PdggneGK05uprZ2D7lux/snXcArIm8Q=";

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
    maintainers = with maintainers; [
      zimbatm
      zygot
    ];
    mainProgram = "rke2";
    broken = stdenv.isDarwin;
  };
}

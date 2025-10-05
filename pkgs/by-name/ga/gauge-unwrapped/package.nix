{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.21";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${version}";
    hash = "sha256-mUuoGLAVUShhNsSjURCL6yWcIW+K7P8KEBwBoBelgyw=";
  };

  vendorHash = "sha256-WyQbvZNd61L4Bz5btZ2hkrCTb5iuJJU5yNDzuYR5Sdc=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      vdemeester
      marie
    ];
  };
}

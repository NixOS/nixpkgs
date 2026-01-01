{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gauge";
<<<<<<< HEAD
  version = "1.6.22";
=======
  version = "1.6.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6RJj+sDffqzdMlMkE/rJ7AEKYcxDQBR86fjlaNDb6M0=";
  };

  vendorHash = "sha256-nxd+3hKHLUiHpSGTJpD5QRFJ4e0Boq5MTijmND56Uug=";
=======
    hash = "sha256-mUuoGLAVUShhNsSjURCL6yWcIW+K7P8KEBwBoBelgyw=";
  };

  vendorHash = "sha256-WyQbvZNd61L4Bz5btZ2hkrCTb5iuJJU5yNDzuYR5Sdc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  excludedPackages = [
    "build"
    "man"
  ];

<<<<<<< HEAD
  meta = {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      vdemeester
      marie
    ];
  };
}

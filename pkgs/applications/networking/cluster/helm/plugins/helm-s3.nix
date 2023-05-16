{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-s3";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hypnoglow";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-81Rzqu2fj6xSZbKvAhHzaGnr/3ACZvqJhYe+6Vyc0qk=";
  };

  vendorHash = "sha256-Jvfl0sdZXV497RIgoZUJD0zK/pXK6yeAnuSdq42nky8=";
=======
    sha256 = "sha256-2BQ/qtoL+iFbuLvrJGUuxWFKg9u1sVDRcRm2/S0mgyc=";
  };

  vendorSha256 = "sha256-/9TiY0XdkiNxW5JYeC5WD9hqySCyYYU8lB+Ft5Vm96I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

<<<<<<< HEAD
  # NOTE: make test-unit, but skip awsutil, which needs internet access
  checkPhase = ''
    go test $(go list ./... | grep -vE '(awsutil|e2e)')
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "cmd/helm-s3" ];

=======
  checkPhase = ''
    make test-unit
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "A Helm plugin that allows to set up a chart repository using AWS S3";
=======
    description = "A Helm plugin that shows a diff";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/hypnoglow/helm-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}

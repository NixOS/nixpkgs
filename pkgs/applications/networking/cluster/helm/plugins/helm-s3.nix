{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-s3";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "hypnoglow";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2BQ/qtoL+iFbuLvrJGUuxWFKg9u1sVDRcRm2/S0mgyc=";
  };

  vendorSha256 = "sha256-/9TiY0XdkiNxW5JYeC5WD9hqySCyYYU8lB+Ft5Vm96I=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  checkPhase = ''
    make test-unit
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "A Helm plugin that shows a diff";
    homepage = "https://github.com/hypnoglow/helm-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}

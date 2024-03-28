{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "kpt";
  version = "1.0.0-beta.49";

  src = fetchFromGitHub {
    owner = "kptdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-whqA1ACN7vXSDWVi55/fJKnuBrDCIdOpyDS8KNrhZq0=";
  };

  vendorHash = "sha256-NQ/JqXokNmr8GlIhqTJb0JFyU2mAEXO+2y5vI79TuX4=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    mainProgram = "kpt";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
  };
}

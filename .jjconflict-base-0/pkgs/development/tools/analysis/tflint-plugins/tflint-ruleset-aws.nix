{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tflint-ruleset-aws";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-osQhLnOuJQqyKm24mgaEuYKy69cPvnR3XHU0JgVKA84=";
  };

  vendorHash = "sha256-mhc8HJG+sI8pZG/D+91+pyi0RGK0WfZV6ZNuH1bUfhk=";

  # upstream Makefile also does a  go test $(go list ./... | grep -v integration)
  preCheck = ''
    rm integration/integration_test.go
  '';

  postInstall = ''
    mkdir -p $out/github.com/terraform-linters/${pname}/${version}
    mv $out/bin/${pname} $out/github.com/terraform-linters/${pname}/${version}/
    # remove other binaries from bin
    rm -R $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/terraform-linters/tflint-ruleset-aws";
    changelog = "https://github.com/terraform-linters/tflint-ruleset-aws/blob/v${version}/CHANGELOG.md";
    description = "TFLint ruleset plugin for Terraform AWS Provider";
    maintainers = with maintainers; [ flokli ];
    license = with licenses; [ mpl20 ];
  };
}

{ lib
, buildGoModule
, buildGo119Module
, fetchFromGitHub
, nixosTests
}:

let
  generic =
    { buildGoModule, version, sha256, vendorSha256, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorSha256" ];
    in
    buildGoModule (rec {
      pname = "nomad";
      inherit version vendorSha256;

      subPackages = [ "." ];

      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = pname;
        rev = "v${version}";
        inherit sha256;
      };

      # ui:
      #  Nomad release commits include the compiled version of the UI, but the file
      #  is only included if we build with the ui tag.
      tags = [ "ui" ];

      meta = with lib; {
        homepage = "https://www.nomadproject.io/";
        description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
        platforms = platforms.unix;
        license = licenses.mpl20;
        maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes maxeaubrey techknowlogick ];
      };
    } // attrs');
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_4;

  nomad_1_2 = generic {
    buildGoModule = buildGo119Module;
    version = "1.2.15";
    sha256 = "sha256-p9yRjSapQAhuHv+slUmYI25bUb1N1A7LBiJOdk1++iI=";
    vendorSha256 = "sha256-6d3tE337zVAIkzQzAnV2Ya5xwwhuzmKgtPUJcJ9HRto=";
  };

  nomad_1_3 = generic {
    buildGoModule = buildGo119Module;
    version = "1.3.8";
    sha256 = "sha256-hUmDWgGV8HAXew8SpcbhaiaF9VfBN5mk1W7t5lhnZ9I=";
    vendorSha256 = "sha256-IfYobyDFriOldJnNfRK0QVKBfttoZZ1iOkt4cBQxd00=";
  };

  nomad_1_4 = generic {
    buildGoModule = buildGo119Module;
    version = "1.4.3";
    sha256 = "sha256-GQVfrn9VlzfdIj73W3hBpHcevsXZcb6Uj808HUCZUUg=";
    vendorSha256 = "sha256-JQRpsQhq5r/QcgFwtnptmvnjBEhdCFrXFrTKkJioL3A=";
    passthru.tests.nomad = nixosTests.nomad;
  };
}

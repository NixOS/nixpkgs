{ lib
, buildGoModule
, buildGo120Module
, fetchFromGitHub
, nixosTests
, installShellFiles
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

      nativeBuildInputs = [ installShellFiles ];

      # ui:
      #  Nomad release commits include the compiled version of the UI, but the file
      #  is only included if we build with the ui tag.
      tags = [ "ui" ];

      postInstall = ''
        echo "complete -C $out/bin/nomad nomad" > nomad.bash
        installShellCompletion nomad.bash
      '';

      meta = with lib; {
        homepage = "https://www.nomadproject.io/";
        description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
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

  nomad = nomad_1_5;

  nomad_1_2 = generic {
    buildGoModule = buildGo120Module;
    version = "1.2.16";
    sha256 = "sha256-fhfUpcG91EgIzJ4mCS7geyIJyTSHS2e8t4yYiI3PqpQ=";
    vendorSha256 = "sha256-kwCDsGFw+25Mimgt/cTK/Z2H7Qh5n4rjr3kIBvjcPL8=";
  };

  nomad_1_3 = generic {
    buildGoModule = buildGo120Module;
    version = "1.3.9";
    sha256 = "sha256-xfoIzLDG/OfqAPQqeLvQZ11uESWFNyOyLP6Imi+S96w=";
    vendorSha256 = "sha256-kW0goicoM1lM1NEHPTfozg2EKR1daf33UxT/mVabyfY=";
  };

  nomad_1_4 = generic {
    buildGoModule = buildGo120Module;
    version = "1.4.6";
    sha256 = "sha256-l4GvQIS5JSSgjBjPivAKAb7gKlVLw4WoZpPR8LxnLNc=";
    vendorSha256 = "sha256-05BhKF6kx0wbu74cidpTFhUN668R/AxV6qWmchCm/WE=";
    passthru.tests.nomad = nixosTests.nomad;
  };

  nomad_1_5 = generic {
    buildGoModule = buildGo120Module;
    version = "1.5.8";
    sha256 = "sha256-5VAUNunQz4s1Icd+s5i8Kx6u1P0By+ikl4C5wXM1oho=";
    vendorSha256 = "sha256-y3WiQuoQn6SdwTgtPWuB6EBtsJC+YleQPzownZQNkno=";
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo120Module;
    version = "1.6.1";
    sha256 = "sha256-RsyGUaLteGiNf0PTkKLcjHTevhKb/mNx2JORpXhHJMw=";
    vendorSha256 = "sha256-Y3O7ADzZPlLWFbXSYBcI6b5MAhMD0UnkhQxO9VJMpOY=";
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}

{ lib
, buildGoModule
, buildGo120Module
, buildGo121Module
, fetchFromGitHub
, nixosTests
, installShellFiles
}:

let
  generic =
    { buildGoModule, version, sha256, vendorHash, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorHash" ];
    in
    buildGoModule (rec {
      pname = "nomad";
      inherit version vendorHash;

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
        maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes amaxine techknowlogick cottand ];
      };
    } // attrs');
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_6;

  nomad_1_4 = generic {
    buildGoModule = buildGo120Module;
    version = "1.4.12";
    sha256 = "sha256-dO98FOaO5MB5pWzeF705s/aBDTaF0OyWnVxWGB91suI=";
    vendorHash = "sha256-D5TcTZa64Jr47u4mrTXK4lUIC5gfBQNVgL6QKh1CaQM=";
    passthru.tests.nomad = nixosTests.nomad;
  };

  nomad_1_5 = generic {
    buildGoModule = buildGo120Module;
    version = "1.5.8";
    sha256 = "sha256-5VAUNunQz4s1Icd+s5i8Kx6u1P0By+ikl4C5wXM1oho=";
    vendorHash = "sha256-y3WiQuoQn6SdwTgtPWuB6EBtsJC+YleQPzownZQNkno=";
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo121Module;
    version = "1.6.4";
    sha256 = "sha256-tlbuxKCm7he1Tij4BYKGvv7a6LKiyWgs2PvbcWg/7A0=";
    vendorHash = "sha256-PrQit4egSq/pkILb6M7A3gsiQvLPABhyLXWgv8GFz/Y=";
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_7 = generic {
    buildGoModule = buildGo121Module;
    version = "1.7.1";
    sha256 = "sha256-dlKlpgQRug/72UmIogOkKNGBT3sPjgGVVuvzHZ4vh3c=";
    vendorHash = "sha256-MZmhFdZZBkKZDgON1ewVm9Z9jZ1EULp/yMT9q6fCqIw=";
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}

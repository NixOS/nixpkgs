{ lib
, buildGoModule
, buildGo121Module
, fetchFromGitHub
, nixosTests
, installShellFiles
}:

let
  generic =
    { buildGoModule, version, sha256, vendorHash, license, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "buildGoModule" "version" "sha256" "vendorHash" "license" ];
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
        description = "Distributed, Highly Available, Datacenter-Aware Scheduler";
        mainProgram = "nomad";
        inherit license;
        maintainers = with maintainers; [ rushmorem pradeepchhetri techknowlogick cottand ];
      };
    } // attrs');
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_7;

  nomad_1_4 = throw "nomad_1_4 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade";

  nomad_1_5 = generic {
    buildGoModule = buildGo121Module;
    version = "1.5.15";
    sha256 = "sha256-OFmGOU+ObA0+BS48y0ZyyxR+VI5DYL39peVKcyVHgGI=";
    vendorHash = "sha256-Ds94lB43cyMNyRJZti0mZDWGTtSdwY31dDijfAUxR0I=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo121Module;
    version = "1.6.10";
    sha256 = "sha256-kiMdpJzjF0S7lrTX3sBFkWm0Gac9a+qlwCPcMKeVXXQ=";
    vendorHash = "sha256-qnsPPV/NWTrqUa1v1CL16WfCH7B0zW9ZSnEmtqvotqI=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_7 = generic {
    buildGoModule = buildGo121Module;
    version = "1.7.7";
    sha256 = "sha256-4nuRheidR6rIoytrnDQdIP69f+sBLJ3Ias5DvqVaLFc=";
    vendorHash = "sha256-ZuaD8iDsT+/eW0QUavf485R804Jtjl76NcQWYHA8QII=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_8 = generic {
    buildGoModule = buildGo121Module;
    version = "1.8.0";
    sha256 = "sha256-j/9wvnxYhv6h344904cO2Fi6pNeSV5IfcqS4mSjDqpo=";
    vendorHash = "sha256-jNdLLs/mfARl5Uk9RalwSDFLAKqIISEkek3l1wV8EYE=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}

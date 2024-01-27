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
        description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
        inherit license;
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

  nomad = nomad_1_7;

  nomad_1_4 = throw "nomad_1_4 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade";

  nomad_1_5 = generic {
    buildGoModule = buildGo121Module;
    version = "1.5.13";
    sha256 = "sha256-SFPjcr3W6Sj1n+1ooi1HDMQEapgGapVy4HtqxSIVi9U=";
    vendorHash = "sha256-F9lzO3jMVbDq8sA4rBo81vmIoOhK2N8d4HXX58HOw18=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_6 = generic {
    buildGoModule = buildGo121Module;
    version = "1.6.6";
    sha256 = "sha256-E7HLBABOtDO/BUc2+4mD4yJ/sfy85gy67ZylRTZI3Cg=";
    vendorHash = "sha256-6jq00RsukuP8OSkXhqYqQxpXtp/jm/GChEwEJTVyO10=";
    license = lib.licenses.mpl20;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_7 = generic {
    buildGoModule = buildGo121Module;
    version = "1.7.3";
    sha256 = "sha256-Rl/bDglO87kbtxFCy0eiTQVJCAwPobQI4GJQOflvXhk=";
    vendorHash = "sha256-M8lGzUvPY8hNhN9ExHasfnLhe+DYBb86RXr1wdrRbgw=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}

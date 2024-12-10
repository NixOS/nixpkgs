{
  lib,
  buildGoModule,
  buildGo122Module,
  buildGo123Module,
  fetchFromGitHub,
  nixosTests,
  installShellFiles,
}:

let
  generic =
    {
      buildGoModule,
      version,
      sha256,
      vendorHash,
      license,
      ...
    }@attrs:
    let
      attrs' = builtins.removeAttrs attrs [
        "buildGoModule"
        "version"
        "sha256"
        "vendorHash"
        "license"
      ];
    in
    buildGoModule (
      rec {
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

        ldflags = [
          "-X github.com/hashicorp/nomad/version.Version=${version}"
          "-X github.com/hashicorp/nomad/version.VersionPrerelease="
          "-X github.com/hashicorp/nomad/version.BuildDate=1970-01-01T00:00:00Z"
        ];

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
          maintainers = with maintainers; [
            rushmorem
            pradeepchhetri
            techknowlogick
            cottand
          ];
        };
      }
      // attrs'
    );

  throwUnsupportaed =
    version:
    "${version} is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade";
in
rec {
  # Nomad never updates major go versions within a release series and is unsupported
  # on Go versions that it did not ship with. Due to historic bugs when compiled
  # with different versions we pin Go for all versions.
  # Upstream partially documents used Go versions here
  # https://github.com/hashicorp/nomad/blob/master/contributing/golang.md

  nomad = nomad_1_8;

  nomad_1_4 = throwUnsupportaed "nomad_1_4";

  nomad_1_5 = throwUnsupportaed "nomad_1_5";

  nomad_1_6 = throwUnsupportaed "nomad_1_6";

  nomad_1_7 = generic {
    buildGoModule = buildGo122Module;
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
    buildGoModule = buildGo122Module;
    version = "1.8.4";
    sha256 = "sha256-BzLvALD65VqWNB9gx4BgI/mYWLNeHzp6WSXD/1Xf0Wk=";
    vendorHash = "sha256-0mnhZeiCLAWvwAoNBJtwss85vhYCrf/5I1AhyXTFnWk=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };

  nomad_1_9 = generic {
    buildGoModule = buildGo123Module;
    version = "1.9.2";
    sha256 = "sha256-HIyRzujAGwhB2anbxidhq5UpWYHkigyyHfxIUwMF5X8=";
    vendorHash = "sha256-YIOTdD+oRDdEHkBzQCUuKCz7Wbj4mFjrZY0J3Cte400=";
    license = lib.licenses.bsl11;
    passthru.tests.nomad = nixosTests.nomad;
    preCheck = ''
      export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
    '';
  };
}

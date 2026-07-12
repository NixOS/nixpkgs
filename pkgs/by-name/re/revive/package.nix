{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  testers,
  revive,
}:

buildGoModule (finalAttrs: {
  pname = "revive";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FA3IP8TNY911CasYI+m+qpNCvFgMcJ0jUeT1Gk8frAw=";

    postFetch = ''
      # The repository currently has a 'v1' and 'V1' directory.
      # On Darwin these are treated as the same. To prevent a hash mismatch, remove the directory.
      rm -r $out/testdata/package_directory_mismatch/api
    '';
  };

  vendorHash = "sha256-KxDWd+fd30eOttNEB6kQDxc2Lnf5Rj2zTCohjyfjMnU=";

  # Only build the revive package at the root.
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mgechev/revive/cli.version=${finalAttrs.version}"
    "-X github.com/mgechev/revive/cli.builtBy=nix"
  ];

  passthru.tests = {
    version = testers.testVersion { package = revive; };
    simple-execution = testers.runCommand {
      name = "Executes the linter";
      nativeBuildInputs = [ finalAttrs.finalPackage ];
      script = ''
        # Write a simple go program.
        cat > main.go << EOF
        // The main package
        package main

        import "fmt"

        func main() {
          fmt.Println("Hello World")
        }
        EOF

        # This will return an exit status of 1 if there are errors and the test will fail.
        revive -set_exit_status main.go

        # Test successful.
        touch $out
      '';
    };
  };

  meta = {
    description = "Fast, configurable, extensible, flexible, and beautiful linter for Go";
    mainProgram = "revive";
    longDescription = "Drop-in replacement for golint. Revive provides a framework for development of custom rules, and lets you define a strict preset for enhancing your development & code review processes";
    homepage = "https://revive.run";
    downloadPage = "https://github.com/mgechev/revive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewfield ];
  };
})

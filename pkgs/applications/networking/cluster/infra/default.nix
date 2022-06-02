{ pkgs, stdenv, lib, buildGoModule, fetchFromGitHub, nodejs }:
let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
    inherit pkgs nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };

  nodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
    inherit nodeEnv;
  };

  nodeDependencies = (nodePackages.shell.override (old: {})).nodeDependencies;
in buildGoModule rec {
  pname = "infra";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = "infra";
    rev = "v${version}";
    sha256 = "sha256-46pJEkXanfzak23RU3MPrHp7Iswtb6ItIY5QI5YGFGc=";
  };

  ui = stdenv.mkDerivation {
    pname = "infra-ui";
    inherit version;

    src = pkgs.applyPatches {
      name = "infra-ui-patched";
      src = "${src}/ui";
      patches = [ ./package-json.patch ];
    };

    buildInputs = [ nodejs ];
    buildPhase = ''
      echo '${nodeDependencies}'
      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"

      next build
    '';

    installPhase = ''
      next export -o $out/
    '';
  };

  preBuild = ''
    mkdir -p internal/server/ui/static
    cp -r ${ui}/* internal/server/ui/static
  '';

  vendorSha256 = "sha256-1oxOtvf8Y+dyw2+Pj0TcUEmckTA6t6/JDjqg8nUmVQg=";

  excludedPackages = [ "internal/docgen" "internal/openapigen" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/infrahq/infra/internal.Branch=main"
    "-X github.com/infrahq/infra/internal.Version=v${version}"
    "-X github.com/infrahq/infra/internal.Prerelease="
    "-X github.com/infrahq/infra/internal.Metadata="
    "-X github.com/infrahq/infra/internal.Commit=${src.rev}"
    "-X github.com/infrahq/infra/internal.Date=unknown"
  ];

  # Tests fail due to trying to create a directory without permission.
  #
  # panic: mkdir /homeless-shelter: permission denied
  #
  # goroutine 1 [running]:
  # github.com/infrahq/infra/internal/cmd.init.0()
  #         github.com/infrahq/infra/internal/cmd/agent.go:27 +0xa5
  # FAIL    github.com/infrahq/infra/internal/cmd   0.017s
  # FAIL
  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    broken = stdenv.isDarwin && stdenv.isx86_64;
    description = "Single sign-on for infrastructure";
    homepage = "https://infrahq.com/";
    changelog = "https://github.com/infrahq/infra/tag/${version}";
    license = licenses.elastic20;
    maintainers = with maintainers; [ matthewpi ];
  };
}

{ lib, buildGoModule, buildGoPackage, fetchFromGitHub, installShellFiles, pkgsBuildBuild, stdenv }:

let
  # Argo can package a static server in the CLI using the `staticfiles` go module.
  # We build the CLI without the static server for simplicity, but the tool is still required for
  # compilation to succeed.
  # See: https://github.com/argoproj/argo/blob/d7690e32faf2ac5842468831daf1443283703c25/Makefile#L117
  staticfiles = pkgsBuildBuild.buildGoPackage rec {
    name = "staticfiles";
    src = fetchFromGitHub {
      owner = "bouk";
      repo = "staticfiles";
      rev = "827d7f6389cd410d0aa3f3d472a4838557bf53dd";
      sha256 = "0xarhmsqypl8036w96ssdzjv3k098p2d4mkmw5f6hkp1m3j67j61";
    };

    goPackagePath = "bou.ke/staticfiles";
  };
in
buildGoModule rec {
  pname = "argo";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "sha256-ST5XVgij1h+4EWLlwdFmIYZ0RPSH5IoTw0YdP0a+Sa4=";
  };

  vendorSha256 = "sha256-h6Ioy1wBOAOCGcqcLlPyqX5pyx22BIiHKx4ct0HmnyA=";

  doCheck = false;

  subPackages = [ "cmd/argo" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p ui/dist/app
    echo "Built without static files" > ui/dist/app/index.html

    ${staticfiles}/bin/staticfiles -o server/static/files.go ui/dist/app
  '';

  ldflags = [
    "-s" "-w"
    "-X github.com/argoproj/argo-workflows/v3.buildDate=unknown"
    "-X github.com/argoproj/argo-workflows/v3.gitCommit=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTag=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTreeState=clean"
    "-X github.com/argoproj/argo-workflows/v3.version=${version}"
  ];

  postInstall = ''
    for shell in bash zsh; do
      ${if (stdenv.buildPlatform == stdenv.hostPlatform)
        then "$out/bin/argo"
        else "${pkgsBuildBuild.argo}/bin/argo"
      } completion $shell > argo.$shell
      installShellCompletion argo.$shell
    done
  '';

  meta = with lib; {
    description = "Container native workflow engine for Kubernetes";
    homepage = "https://github.com/argoproj/argo";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
    platforms = platforms.unix;
  };
}

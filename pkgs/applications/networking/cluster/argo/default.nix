{ lib, buildGoModule, buildGoPackage, fetchFromGitHub, installShellFiles }:

let
  # Argo can package a static server in the CLI using the `staticfiles` go module.
  # We build the CLI without the static server for simplicity, but the tool is still required for
  # compilation to succeed.
  # See: https://github.com/argoproj/argo/blob/d7690e32faf2ac5842468831daf1443283703c25/Makefile#L117
  staticfiles = buildGoPackage rec {
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
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "1x44mgvnbn47a33xnhnh9bxxvj1vsr32lvh9bq6w5hpmxb7qbq4f";
  };

  vendorSha256 = "1vqmzz76lcwwnw89n4lyg4jjf7wbdgn9sdzwsgrjwkj8ax7d48cv";

  subPackages = [ "cmd/argo" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p ui/dist/app
    echo "Built without static files" > ui/dist/app/index.html

    ${staticfiles}/bin/staticfiles -o server/static/files.go ui/dist/app
  '';

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/argoproj/argo.version=${version}
      -X github.com/argoproj/argo.gitCommit=${src.rev}
      -X github.com/argoproj/argo.gitTreeState=clean
      -X github.com/argoproj/argo.gitTag=${version}
  '';

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/argo completion $shell > argo.$shell
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

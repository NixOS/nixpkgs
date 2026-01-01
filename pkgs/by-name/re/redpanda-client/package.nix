{
  buildGoModule,
  doCheck ? !stdenv.hostPlatform.isDarwin, # Can't start localhost test server in MacOS sandbox.
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
let
<<<<<<< HEAD
  version = "25.3.4";
=======
  version = "25.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "redpanda";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-I5WtwY6CODf64x5ZjFBFQagQ3HkIBvuJil92sajSqRM=";
=======
    sha256 = "sha256-/TodUIBsby4ewoyU72/5jHoBDoFHsSHqjJI7vtBlELU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
buildGoModule rec {
  pname = "redpanda-rpk";
  inherit doCheck src version;
  modRoot = "./src/go/rpk";
  runVend = false;
<<<<<<< HEAD
  vendorHash = "sha256-AZQmI4foYhxyaWUfr9QzbyMX/q+737h1uc//9rXBMcY=";
=======
  vendorHash = "sha256-6iyHM7SWqorjjebmZEJKzUU1w0waTywAY//UcfikdAo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.version=${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.rev=v${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/container/common.tag=v${version}"''
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/rpk generate shell-completion $shell > rpk.$shell
      installShellCompletion rpk.$shell
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      avakhrenev
      happysalada
    ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      avakhrenev
      happysalada
    ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rpk";
  };
}

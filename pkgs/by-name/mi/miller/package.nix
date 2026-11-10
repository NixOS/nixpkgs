{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.22.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIdX7yO45jjaYApNCays4knwLIjRG8GNkWeNGXKIs6M=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-9ioeIPtEWmC3vY3rIPdRl3+0a2cKpH7VhmLVi7ioQK8=";

  subPackages = [ "cmd/mlr" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/mlr.1
  '';

  meta = {
    changelog = "https://github.com/johnkerl/miller/releases/tag/${finalAttrs.src.tag}";
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage = "https://miller.readthedocs.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms = lib.platforms.all;
  };
})

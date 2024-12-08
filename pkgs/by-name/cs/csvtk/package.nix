{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:
let
  version = "0.32.0";
in
buildGoModule {
  pname = "csvtk";
  inherit version;

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "csvtk";
    rev = "refs/tags/v${version}";
    hash = "sha256-t1juidSPCOEFsApvMWW8F/gF2F6JwK0Ds7O/GSZRg30=";
  };

  vendorHash = "sha256-T9flXxly3i8SKQlhp4AF2FNCqgcnGAHxv5b7nqzM3DI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      csvtkBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.csvtk;
    in
    ''
      for shell in bash zsh fish; do
        ${csvtkBin}/bin/csvtk genautocomplete --shell $shell --file csvtk.$shell
        installShellCompletion csvtk.$shell
      done
    '';

  meta = {
    description = "Cross-platform, efficient and practical CSV/TSV toolkit in Golang";
    changelog = "https://github.com/shenwei356/csvtk/releases/tag/v${version}";
    homepage = "https://github.com/shenwei356/csvtk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "csvtk";
  };
}

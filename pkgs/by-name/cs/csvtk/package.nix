{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:
let
  version = "0.37.0";
in
buildGoModule {
  pname = "csvtk";
  inherit version;

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "csvtk";
    tag = "v${version}";
    hash = "sha256-dpWxLOckdA0tNhSM8wGqBag/cXmMFhonybN+W1+KBXA=";
  };

  vendorHash = "sha256-wi7WPwCg0MoNxgCLZO1UxG4M0g/Vo/GCiCGu8c5avyU=";

  # stale upstream test: asserts byte length, but expr-lang now returns rune count
  checkFlags = [ "-skip=TestMutate3" ];

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

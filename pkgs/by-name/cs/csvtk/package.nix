{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.30.0";
in
buildGoModule {
  pname = "csvtk";
  inherit version;

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "csvtk";
    rev = "refs/tags/v${version}";
    hash = "sha256-xq56dErO0vjG9bZ5aISIFWX4IOHaQksE9W1is2HiFuQ=";
  };

  vendorHash = "sha256-wJedDF7QIg8oWc/QX+rZDyq/nkAW+PMb8EYb0RGJxQM=";

  meta = {
    description = "Cross-platform, efficient and practical CSV/TSV toolkit in Golang";
    changelog = "https://github.com/shenwei356/csvtk/releases/tag/v${version}";
    homepage = "https://github.com/shenwei356/csvtk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "csvtk";
  };
}

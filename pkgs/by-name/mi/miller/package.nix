{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.17.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-a147/0w+e+y4zCDs9/NGmtVK8rp//5I+QAsDBzj/sRg=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-6BStDF95QXk55m2QujCqxoE0nciP7blyN/fFCHaTy6I=";

  postInstall = ''
    mkdir -p $man/share/man/man1
    mv ./man/mlr.1 $man/share/man/man1
  '';

  subPackages = [ "cmd/mlr" ];

  meta = {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage = "https://github.com/johnkerl/miller";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms = lib.platforms.all;
  };
})

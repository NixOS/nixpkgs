{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.18.1";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pXxXUw956M5EUhL1TFtQp1JTXQwQK9qxp2vjBkozi/0=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-ZnNEOVChF3kizfjti6Cgexvt/5UPIRQsyfUz8c03EKc=";

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

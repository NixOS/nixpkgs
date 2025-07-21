{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "miller";
  version = "6.14.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-tpM+Y65zYvnTd9VNJPDTWyj0RC+VmdmVCNzXyVGs/EI=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-KgQZg8+6Vo4t0yx7AwuOyRWIMT7vwUO5nfDgBSVceIA=";

  postInstall = ''
    mkdir -p $man/share/man/man1
    mv ./man/mlr.1 $man/share/man/man1
  '';

  subPackages = [ "cmd/mlr" ];

  meta = with lib; {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage = "https://github.com/johnkerl/miller";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms = platforms.all;
  };
}

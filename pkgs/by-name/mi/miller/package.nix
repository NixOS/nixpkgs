{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "miller";
  version = "6.15.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-r+eayyxI+qFypDHavv9fOAl3rjjKeQxy8tXetmh/ZAI=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-siLrJOMvsv8MkDVVK8xPn4tpyYSqoYT2Iku7ZP0NCk0=";

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

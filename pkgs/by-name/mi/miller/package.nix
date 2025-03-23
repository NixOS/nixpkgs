{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "miller";
  version = "6.13.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-eHiYIw/sQMXLow2Vy4zFTGeON28LmG0pK2Uca4ooInU=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-oc6Lp4rQ+MLmQDVcuNJ3CqYH277Vuuwu4zSSO2ICXsw=";

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

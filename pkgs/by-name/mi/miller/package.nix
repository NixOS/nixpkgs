{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.20.2";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-unzjbPuOmppEY56JnV+A3TZuaHMLNeZS3n7tKpudCXk=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-ZA9ueehDXsRI3eEE44hJziWKAAsZXkF77hBkYvX2k+U=";

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

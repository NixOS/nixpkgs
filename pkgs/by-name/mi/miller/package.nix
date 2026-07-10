{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.19.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kIhJ9wysaWnZNvaWaNE32FQOHFDNBtUl41d1Z45VFac=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-PzklwkT2Chs3z1UzLX9g9hpDGTHmyxfiT0igSntXPqo=";

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

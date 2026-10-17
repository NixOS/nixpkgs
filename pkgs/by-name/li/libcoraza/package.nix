{
  lib,
  pkgs,

  writableTmpDirAsHomeHook,

  coreutils,

  libtool,
  autoconf,
  automake,
  go,
}:

let
  version = "1.7.0";
  src = pkgs.fetchFromGitHub {
    owner = "corazawaf";
    repo = "libcoraza";
    rev = "v${version}";
    hash = "sha256-dEzi9GOiOZezMJYiWe2PzGQwojxnT0DRzX1huuYQ8FY=";
  };
  vendoredGoModules =
    (pkgs.buildGoModule {
      pname = "libcoraza-go-vendored";
      inherit version src;
      vendorHash = "sha256-CJy3ptEDWBSTqwdy0/06oZqSS2ms5qb+CY80ZzBCbk4=";
      preConfigure = "go get -u github.com/corazawaf/coraza/v3.7.0";
      # some tests depend on hardcoded /bin/echo
      doCheck = true;
      preCheck = ''
        substituteInPlace internal/operators/inspect_file_test.go --replace-warn "/bin/echo" "${coreutils}/bin/echo"
      '';
    }).goModules;
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "libcoraza";
  inherit version src;

  nativeBuildInputs = [
    # go downloads dependencies to homedir by default
    writableTmpDirAsHomeHook
    libtool
    autoconf
    automake
    go
  ];

  __structuredAttrs = true;
  strictDeps = true;

  env.GOFLAGS = "-mod=vendor";

  postUnpack = ''
    mkdir -p source/vendor/
    cp -r ${vendoredGoModules}/* source/vendor/
  '';
  preConfigure = "./build.sh";
  preBuild = "patchShebangs tests/check_result.sh";

  meta = {
    description = "C API for Coraza";
    homepage = "https://github.com/corazawaf/libcoraza";
    license = [ lib.licenses.asl20 ];
  };
})

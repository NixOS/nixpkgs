{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  buildGoModule,
  cmake,
  ncurses,
  asio,
}:

let
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "pan-bindings";
    tag = "v${version}";
    hash = "sha256-FpjbfmJwCx+aZxipE1QQTgOlXHtv2VkIKWSMQylr+WM=";
  };
  goDeps = (
    buildGoModule {
      name = "pan-bindings-goDeps";
      inherit src version;
      prePatch = ''
        # can be removed once https://github.com/NixOS/nixpkgs/pull/414434 is fully merged
        substituteInPlace go/go.mod --replace-fail "toolchain go1.24.4" "toolchain go1.24.3"
      '';
      modRoot = "go";
      vendorHash = "sha256-3MybV76pHDnKgN2ENRgsyAvynXQctv0fJcRGzesmlww=";
    }
  );
in

stdenv.mkDerivation {
  name = "pan-bindings";

  inherit src version;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
    "-DBUILD_EXAMPLES=0"
  ];

  prePatch = ''
    export HOME=$TMP
    cp -r --reflink=auto ${goDeps.goModules} go/vendor
    # can be removed once https://github.com/NixOS/nixpkgs/pull/414434 is fully merged
    substituteInPlace go/go.mod --replace-fail "toolchain go1.24.4" "toolchain go1.24.3"
  '';

  patches = [
    # can be removed in the next release when the pull request is merged or the build issue otherwise resolved
    (fetchpatch2 {
      name = "fix-darwin-build";
      url = "https://patch-diff.githubusercontent.com/raw/lschulz/pan-bindings/pull/4.patch";
      hash = "sha256-0/lg3TxSosELtKycn+oJtK0JBDFQrQBbwUPu2ah9lgI=";
    })
  ];

  buildInputs = [
    ncurses
    asio
  ];

  nativeBuildInputs = [
    cmake
    goDeps.go
  ];

  meta = with lib; {
    description = "SCION PAN Bindings for C, C++, and Python";
    homepage = "https://github.com/lschulz/pan-bindings";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "pan-bindings";
    platforms = platforms.all;
  };
}

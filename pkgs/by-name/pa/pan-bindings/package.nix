{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  cmake,
  ncurses,
  asio,
}:

let
  version = "unstable-2024-03-03";
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "pan-bindings";
    rev = "4361d30f1c5145a70651c259f2d56369725b0d15";
    hash = "sha256-0WxrgXTCM+BwGcjjWBBKiZawje2yxB5RRac6Sk5t3qc=";
  };
  goDeps = (
    buildGoModule {
      name = "pan-bindings-goDeps";
      inherit src version;
      modRoot = "go";
      vendorHash = "sha256-7EitdEJTRtiM29qmVnZUM6w68vCBI8mxZhCA7SnAxLA=";
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

  patchPhase = ''
    runHook prePatch
    export HOME=$TMP
    cp -r --reflink=auto ${goDeps.goModules} go/vendor
    runHook postPatch
  '';

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

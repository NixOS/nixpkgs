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
  version = "unstable-2025-06-15";
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "pan-bindings";
    rev = "708d7f36a0a32816b2b0d8e2e5a4d79f2144f406";
    hash = "sha256-wGHa8NV8M+9dHvn8UqejderyA1UgYQUcTOKocRFhg6U=";
  };
  goDeps = (
    buildGoModule {
      name = "pan-bindings-goDeps";
      inherit src version;
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

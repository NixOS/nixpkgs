{
  stdenv,
  lib,
  fetchFromGitHub,
  go,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "AutomaticComponentToolkit";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Autodesk";
    repo = "AutomaticComponentToolkit";
    rev = "v${finalAttrs.version}";
    sha256 = "1r0sbw82cf9dbcj3vgnbd4sc1lklzvijic2z5wgkvs21azcm0yzh";
  };

  nativeBuildInputs = [
    go
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    cd Source
    go build -o act *.go
  '';

  installPhase = ''
    install -Dm0755 act $out/bin/act
  '';

  meta = {
    description = "Toolkit to automatically generate software components: abstract API, implementation stubs and language bindings";
    mainProgram = "act";
    homepage = "https://github.com/Autodesk/AutomaticComponentToolkit";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

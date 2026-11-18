{
  src,

  stdenv,
  buildGoModule,
}:

let
  filename = "libgomuks${stdenv.hostPlatform.extensions.sharedLibrary}";
in
buildGoModule (finalAttrs: {
  pname = "nexus-gomuks-ffi";
  version = "submodule";

  doCheck = false;

  src = "${src}/gomuks";

  vendorHash = "sha256-feW1rw74GsRx0fkqGLZk6PeR6bUkIt9JnjvirOAThcI=";

  buildPhase = ''
    runHook preBuild

    go build -buildmode=c-shared -o ${filename} -tags goolm,noheic,sqlite_fts5 ./pkg/ffi

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0644 ${filename} -t $out/lib

    runHook postInstall
  '';
})

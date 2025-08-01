{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  stdenv,
  olm,
  unstableGitUpdater,
  withGoolm ? false,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";

in
buildGoModule (finalAttrs: {
  pname = "gomuks-web";
  version = "0.4.0-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "gomuks";
    rev = "fd257ed74c9df42e5b6d14d3c6a283f557f61666";
    hash = "sha256-jMDLfiwkUme2bxE+ZEtUoNMwZ7GuGGzCV2dH1V87YtQ=";
  };

  frontend = buildNpmPackage {
    name = "${finalAttrs.pname}_${finalAttrs.version}-frontend";
    src = "${finalAttrs.src}/web";
    inherit (finalAttrs) version;

    npmDepsHash = "sha256-Mt2gJ1lLT3oQ3RKr3XTVFXkS/Xmjy0gahbdaxxrO+6g=";

    installPhase = ''
      cp -r dist $out
    '';
  };

  vendorHash = "sha256-qeSxxd9ml2ENAYSPkdd1OWqy2DULnwLUVkKje47uT/I=";

  buildInputs = [
    (if withGoolm then stdenv.cc.cc.lib else olm)
  ];

  CGO_LDFLAGS = lib.optional withGoolm cppStdLib;

  tags = lib.optional withGoolm "goolm";

  subPackages = [ "cmd/gomuks" ];

  preBuild = ''
    cp -r ${finalAttrs.frontend} ./web/dist
  '';

  postInstall = ''
    mv $out/bin/gomuks $out/bin/gomuks-web
  '';

  passthru.updateScript = {
    inherit (finalAttrs) frontend;
    updateScript = unstableGitUpdater {
      branch = "main";
    };
  };

  meta = {
    mainProgram = "gomuks-web";
    description = "Matrix client written in Go";
    homepage = "https://github.com/tulir/gomuks";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ctucx ];
    platforms = lib.platforms.unix;
  };
})

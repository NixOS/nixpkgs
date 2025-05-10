{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gysmo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "grosheth";
    repo = "gysmo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ucDcEygh315yD999z6W+kqNBZLj0lGuxZUYjSkOhcJw=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$TMPDIR/go-build
    export HOME=$TMPDIR/home
    go build -mod=vendor -o gysmo src/main.go
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gysmo $out/bin/
    cp -r src/ascii $out/
    cp -r src/config $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Display system information with a focus on customization and aesthetics";
    changelog = "https://github.com/grosheth/gysmo/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/grosheth/gysmo";
    license = licenses.mit;
    maintainers = with maintainers; [ grosheth ];
    platforms = platforms.linux;
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ast-grep,
  versionCheckHook,
  nix-update-script,
  lipo-go,
}:
buildGoModule rec {
  pname = "lipo-go";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "konoui";
    repo = "lipo";
    tag = "v${version}";
    hash = "sha256-FW2mOsshpXCTTjijo0RFdsYX883P2cudyclRtvkCxa0=";
  };
  vendorHash = "sha256-7M6CRxJd4fgYQLJDkNa3ds3f7jOp3dyloOZtwMtCBQk=";

  nativeBuildInputs = [ ast-grep ];

  postPatch =
    # Remove the test case that is not compatible with nix-build
    ''
      ast-grep run \
        --pattern 'func TestLipo_ArchsToLocalFiles($$$) { $$$ }' \
        --rewrite "" \
        pkg/lipo/archs_test.go
    '';
  buildPhase = ''
    runHook preBuild

    make build VERSION=${version} REVISION="" BINARY=$out/bin/lipo

    runHook postBuild
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/lipo";
  versionCheckProgramArg = [ "-version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Designed to be compatible with macOS lipo, written in golang";
    homepage = "https://github.com/konoui/lipo";
    changelog = "https://github.com/konoui/lipo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "lipo";
  };
}

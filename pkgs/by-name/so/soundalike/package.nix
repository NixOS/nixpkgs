{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  chromaprint,
  makeWrapper,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "soundalike";
  version = "0.1.3";

  src = fetchFromCodeberg {
    owner = "derat";
    repo = "soundalike";
    tag = "v${version}";
    hash = "sha256-T3N8/8QP2Lc8cWfFTYtQATIFAYGOHhC0/1Ty1yvyOhU=";
  };

  vendorHash = "sha256-pgS+QzpGpDOdNKG1jMKmXG4UtiH2ssBtYwy3e5nb+pQ=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.buildVersion=${version}"
  ];

  nativeBuildInputs = [
    makeWrapper
    chromaprint
  ];

  doCheck = true;
  # need to grab another repo for music test data
  testDataVersion = "0.0.1";
  testData = fetchFromCodeberg {
    owner = "derat";
    repo = "soundalike-testdata";
    tag = "v${testDataVersion}";
    hash = "sha256-7JQTnEjoYiiaQlnxsGcfj/9PYDWAkWq4/oxyczjEMo4=";
  };
  preCheck = ''
    # add soundalike to PATH to be available for unit tests
    export PATH="$GOPATH/bin:$PATH"
    # need to symlink test data to a relative path
    # that the unit tests are expecting
    ln -sfv ${testData} ./testdata
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  # soundalike depends on fpcalc (chromparint) at runtime, so we
  # need to use wrapProgram to make it available
  postInstall = ''
    wrapProgram $out/bin/soundalike \
      --prefix PATH : ${lib.makeBinPath [ chromaprint ]}
  '';

  meta = {
    description = "Find duplicate audio files using acoustic fingerprints";
    homepage = "https://codeberg.org/derat/soundalike";
    changelog = "https://codeberg.org/derat/soundalike/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ atar13 ];
    mainProgram = "soundalike";
  };
}

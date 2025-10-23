{
  lib,
  buildGoModule,
  fetchFromGitea,
  chromaprint,
  makeWrapper,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "soundalike";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "derat";
    repo = "soundalike";
    tag = "v${version}";
    hash = "sha256-mpYUVTj3Zll6kNuK5Mdzv1R7k5FZy6XFghhzmAPPVM8=";
  };

  vendorHash = "sha256-7hRezOBcjB2wsx/SwV519wg3Azh+0kHMcAoc9aYPM3A=";

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
  testData = fetchFromGitea {
    domain = "codeberg.org";
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

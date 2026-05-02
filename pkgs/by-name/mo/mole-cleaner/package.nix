{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gnused,
  gawk,
  fd,
  gitUpdater,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "mole-cleaner";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${finalAttrs.version}";
    hash = "sha256-dalmW3W/seGZreSWuYP7JN/nMUbs3WyDHzKU83EveeY=";
  };

  vendorHash = "sha256-LznLZ0NO8VBWP95ReAVORUMIDhh7/pgTY5mGNN2tND8=";

  subPackages = [
    "cmd/analyze"
    "cmd/status"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
    coreutils
    gnused
    gawk
  ];

  postInstall = ''
    install -Dm755 mole $out/libexec/mole/mole
    install -Dm755 mo $out/libexec/mole/mo
    cp -r bin lib $out/libexec/mole/

    mv $out/bin/analyze $out/libexec/mole/bin/analyze-go
    mv $out/bin/status $out/libexec/mole/bin/status-go

    patchShebangs $out/libexec/mole

    makeWrapper $out/libexec/mole/mole $out/bin/mole \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          coreutils
          gnused
          gawk
        ]
      }
    makeWrapper $out/libexec/mole/mo $out/bin/mo \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          coreutils
          gnused
          gawk
        ]
      }
  '';

  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/mole --help > /dev/null
    $out/bin/mo --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "V"; };

  meta = {
    description = "CLI tool for cleaning and optimizing macOS systems";
    homepage = "https://github.com/tw93/Mole";
    changelog = "https://github.com/tw93/Mole/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ IanHollow ];
    mainProgram = "mole";
    platforms = lib.platforms.darwin;
  };
})

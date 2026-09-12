{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  dotnetCorePackages,
}:

let
  dotnet =
    with dotnetCorePackages;
    combinePackages [
      runtime_8_0-bin
      aspnetcore_8_0-bin
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bililiverecorder";
  version = "2.19.0";

  src = fetchzip {
    url = "https://github.com/BililiveRecorder/BililiveRecorder/releases/download/v${finalAttrs.version}/BililiveRecorder-CLI-any.zip";
    hash = "sha256-6loic7TagyT60JF/R0rzVffyb6iuwY4OezXiwCeANmM=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r . $out/lib/bililiverecorder
    makeWrapper ${dotnet}/bin/dotnet $out/bin/BililiveRecorder \
      --add-flags $out/lib/bililiverecorder/BililiveRecorder.Cli.dll

    runHook postInstall
  '';

  meta = {
    description = "Convenient free open source bilibili live recording tool";
    homepage = "https://rec.danmuji.org/";
    changelog = "https://github.com/BililiveRecorder/BililiveRecorder/releases/tag/v${finalAttrs.version}";
    mainProgram = "BililiveRecorder";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zaldnoay ];
    platforms = lib.platforms.unix;
  };
})

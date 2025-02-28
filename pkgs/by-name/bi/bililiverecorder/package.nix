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
stdenv.mkDerivation rec {
  pname = "bililiverecorder";
  version = "2.15.1";

  src = fetchzip {
    url = "https://github.com/BililiveRecorder/BililiveRecorder/releases/download/v${version}/BililiveRecorder-CLI-any.zip";
    hash = "sha256-ugzFiuLe+Al3aRvEM3D4kqnaFrFR4Pr95UlEg0VGvvU=";
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
    changelog = "https://github.com/BililiveRecorder/BililiveRecorder/releases/tag/${version}";
    mainProgram = "BililiveRecorder";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zaldnoay ];
    platforms = lib.platforms.unix;
  };
}

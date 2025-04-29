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
  version = "2.16.0";

  src = fetchzip {
    url = "https://github.com/BililiveRecorder/BililiveRecorder/releases/download/v${version}/BililiveRecorder-CLI-any.zip";
    hash = "sha256-VtwXx/q6edE5G+Tl6IB1x36DmXZ6ePqbPW0yl0K4F7U=";
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

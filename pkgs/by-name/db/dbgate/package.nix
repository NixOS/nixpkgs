{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "dbgate";
  version = "7.3.6";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-k3NTcFFxLTsLfOrxhWm5C+EmLNd3dMHRNA7ThA+g4iU=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-ytB06wyR1iyZqGse95lUiETOti0nFdegGk0gLLqmQMs=";
        };
        aarch64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_universal.dmg";
          hash = "sha256-3F2K/0T/AhjXOHjVZ7S77IhOakjRaYpQddScITWLxSc=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "dbgate: ${stdenv.hostPlatform.system} is unsupported.");

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others";
    homepage = "https://dbgate.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    changelog = "https://github.com/dbgate/dbgate/releases/tag/v${version}";
    mainProgram = "dbgate";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    sourceRoot = ".";

    nativeBuildInputs = [ _7zz ];

    unpackPhase = "7zz x ${src}";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  }
else
  let
    appimageContents = appimageTools.extract { inherit pname src version; };
  in
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/dbgate.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/dbgate.desktop \
        --replace-warn "Exec=AppRun --no-sandbox" "Exec=dbgate"
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }

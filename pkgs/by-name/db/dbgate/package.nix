{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "dbgate";
  version = "6.4.2";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-GDQCixckbMlEvp77uAdsTtK8CUT02mUpxluLapO0D78=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-5rMkW9VY1NgeGgG37QyMI78I4G90yuWhkP60o2ClAM8=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-AEYGGT/LIursXtrwVglWvMxYFA9YCqx7q7KXO0q6FZI=";
        };
        aarch64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_universal.dmg";
          hash = "sha256-yWDcIXrD85qr+zx5sbtci1Yw/C6gUjW7NNjfu/sClas=";
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
      "x86_64-darwin"
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

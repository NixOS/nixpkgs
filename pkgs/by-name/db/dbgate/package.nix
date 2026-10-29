{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "dbgate";
  version = "7.2.1";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-OkAyKMXOYxvZomVUB5xIpPKR+b4p3+US7TDMIYeCsoo=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-QR44QZ5QNz/q9Cfp/d5EYjlG84ZmCtBFe8a4aMFEhjQ=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-pTE8Na078B2njCrpuN0xt75PkjwepXnuhphB8Qqcsls=";
        };
        aarch64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_universal.dmg";
          hash = "sha256-luk0vWRc4x3QMYAPquTWiSW9FqTe1IsBm9qOoOeHOps=";
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

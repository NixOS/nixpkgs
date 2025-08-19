{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "dbgate";
  version = "6.6.1";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-8cQ9hhz+nURXuPfgVLClQr6tKgQ/wu7LWIsxhrJWiAQ=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-OldLkZrqvBT6+ECCpRkuys5BOSJNY31ttFa52lWmLLk=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-1wLWK4v5KmkGlFZpROtKALSKDyhF8cJ9pU391FYpXUo=";
        };
        aarch64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_universal.dmg";
          hash = "sha256-bAvqGy7hEQbIhtx4wybxbzATogthcNREkjFDC5kb7WU=";
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

{
  lib,
  stdenv,
  fetchurl,
  _7zz,
  appimageTools,
}:
let
  pname = "dbgate";
  version = "6.0.0";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-HWjz3S8y0lRvhEcYNaNY89fLKvLOzwoLFD2RstWgFPI=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-nUoncYH42maU5cAMkpvKeCnyE8SJTlcfdUCrO5WvhcY=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-ru+TzZ7c9NSOujsHoLxghmKgI4dEMlc45hTHsto2gIY=";
        };
        aarch64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_universal.dmg";
          hash = "sha256-H6RFzgnn/4HHdHrWedFLeLlXizC+TEbD8F/9C4rVMok=";
        };
      }
      .${stdenv.system} or (throw "dbgate: ${stdenv.system} is unsupported.");
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
      meta
      ;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop --replace-warn "Exec=AppRun --no-sandbox" "Exec=$out/bin/${pname}"
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }

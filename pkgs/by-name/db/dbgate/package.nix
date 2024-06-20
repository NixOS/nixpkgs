{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
}:
let
  pname = "dbgate";
  version = "5.3.0";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-FoNph6phZEMjndX6KNtSH8TpOpI0x4rmpTBh11bYV3c=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-HsWT099apLtL5KAy3Shw0uEoXzpWGAyD63L3NhT/JlU=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-bdCwvfmfOCpVW1yTFxsLxveg9uQW1O8ODkCGpiujRCE=";
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
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;
  }

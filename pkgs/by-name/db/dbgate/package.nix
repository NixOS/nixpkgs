{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
}:
let
  pname = "dbgate";
  version = "5.2.8";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-gxojSSk7prhnd9fy56B9H+Cj6COBLc7xPfV8dTvSO0c=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-/Vfd0R+Mzx1CJKkC7dj99pbuuyh8PJtbYlH3wtwVxSM=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-1kC5CNgD3KGR3nd14cBHhYKCThualLKR3CE4KGKh/Hs=";
        };
      }
      .${stdenv.system} or (throw "dbgate: ${stdenv.system} is unsupported.");

  meta = with lib; {
    description = "Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others";
    homepage = "https://github.com/dbgate/dbgate";
    license = licenses.mit;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
    changelog = "https://github.com/dbgate/dbgate/blob/master/CHANGELOG.md";
    mainProgram = "dbgate";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
    ];

    sourceProvenance = [ sourceTypes.binaryNativeCode ];
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

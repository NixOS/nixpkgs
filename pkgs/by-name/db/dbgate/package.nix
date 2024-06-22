{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
}:
let
  pname = "dbgate";
  version = "5.3.1";
  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_arm64.AppImage";
          hash = "sha256-Qz0VA2pHT8muw9RdLg7Y3w3mJ3ubFnqf4dmfdZdnJHI=";
        };
        x86_64-linux = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-linux_x86_64.AppImage";
          hash = "sha256-H/2Tb6ZnO6LJx+rv/ADdItaRMP95x4G3lPNK0sbZn9I=";
        };
        x86_64-darwin = {
          url = "https://github.com/dbgate/dbgate/releases/download/v${version}/dbgate-${version}-mac_x64.dmg";
          hash = "sha256-gZrfv9qe2arytVgiYtX9uwfwC4Z30SHEDiBUXcpF968=";
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

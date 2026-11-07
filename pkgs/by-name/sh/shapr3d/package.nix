{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:
let
  inherit (stdenv.hostPlatform) system;
  unsupported = throw "Shapr3D doesn't support ${system}";
  identifier = "5.910.0.9193";
  url =
    {
      aarch64-darwin = fetchurl {
        url = "https://download.shapr3d.com/mac/Shapr3D-${identifier}.dmg";
        hash = "sha256-aCxANPRSe/biEZVL2fHOHt1h7b2vMDwafuaU9NHoy5Q=";
      };
    }
    .${system} or unsupported;
in
stdenv.mkDerivation {
  pname = "shapr3d";
  version = identifier;
  src = url;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Shapr3D.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/Shapr3D.app
    cp -R . $out/Applications/Shapr3D.app
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.shapr3d.com";
    description = "modeling software geared towards Apple devices";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [
      m-saghir
    ];
    changelog = "https://support.shapr3d.com/hc/en-us/articles/7770045712540-Shapr3D-release-updates";
  };
}

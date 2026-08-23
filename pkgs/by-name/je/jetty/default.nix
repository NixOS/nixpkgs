{
  lib,
  stdenvNoCC,
  fetchurl,
  gitUpdater,
}:

let
  generic =
    { version, hash }:
    stdenvNoCC.mkDerivation rec {
      pname = "jetty";

      inherit version;

      src = fetchurl {
        url = "mirror://maven/org/eclipse/jetty/jetty-home/${version}/jetty-home-${version}.tar.gz";
        inherit hash;
      };

      dontBuild = true;

      installPhase = ''
        mkdir -p $out
        mv etc lib modules start.jar $out
      '';

      passthru.updateScript = gitUpdater {
        url = "https://github.com/jetty/jetty.project.git";
        allowedVersions = "^${lib.versions.major version}\\.";
        ignoredVersions = "(alpha|beta).*";
        rev-prefix = "jetty-";
      };

      meta = {
        changelog = "https://github.com/jetty/jetty.project/releases/tag/jetty-${version}";
        description = "Web server and javax.servlet container";
        homepage = "https://jetty.org/";
        platforms = lib.platforms.all;
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        license = with lib.licenses; [
          asl20
          epl10
        ];
        maintainers = with lib.maintainers; [
          emmanuelrosa
          anthonyroussel
        ];
      };
    };

in
{
  jetty_12 = generic {
    version = "12.1.12";
    hash = "sha256-7sBxMaaCvL+7BBEjKTKnIZa1jxh0EoYpYq8Hreu3d7w=";
  };
}

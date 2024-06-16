{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  runCommand,
  writeText,
  symlinkJoin,
  lessc,
}:

buildNpmPackage {
  pname = "less-plugin-clean-css";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less-plugin-clean-css";
    rev = "b2c3886b7af67ab45a5568e7758bbc2d5b82b112";
    hash = "sha256-dYYcaCLTwAI2T7cWCfiK866Azrw4fnzTE/mkUA6HUFo=";
  };

  npmDepsHash = "sha256-uAYXFxOoUo8tLrYqNeUFMRuaYp2GArGMLaaes1QhLp4=";

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      simple = testers.testEqualContents {
        assertion = "lessc compiles a basic less file";
        expected = writeText "expected" ''
          body h1{color:red}
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [
                (symlinkJoin {
                  name = "less-css-with-plugins";
                  paths = [
                    lessc
                    lessc.plugins.clean-css
                  ];
                })
              ];
              base = writeText "base" ''
                @color: red;
                body {
                  h1 {
                    color: @color;
                  }
                }
              '';
              NODE_PATH = lib.concatMapStringsSep ":" (pkg: "${pkg}/lib/node_modules") [
                lessc
                lessc.plugins.clean-css
              ];
            }
            ''
              lessc $base --clean-css="--s1 --advanced" > $out
              printf "\n" >> $out
            '';
      };
    };
  };

  meta = {
    homepage = "https://github.com/less/less-plugin-clean-css";
    description = " Post-process and compress CSS using clean-css";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}

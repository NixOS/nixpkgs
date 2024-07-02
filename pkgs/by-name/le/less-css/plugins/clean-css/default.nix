{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  runCommand,
  writeText,
  less-css,
}:

buildNpmPackage {
  pname = "less-plugin-clean-css";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less-plugin-clean-css";
    rev = "67a0c3c1311ddd0e7649b7872ef1ec9b9bb1a098";
    hash = "sha256-Q3xqPpTtsUf8dI1kLq1veP2y/pR/boAqYyL4k7ArsxE=";
  };

  npmDepsHash = "sha256-Nsi53Ui/4PLE00NbA3dSBCtBngoVeMHTzJlkpVOX9fI=";

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      simple = testers.testEqualContents {
        assertion = "less-css compiles a basic less file";
        expected = writeText "expected" ''
          body h1{color:red}
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ (less-css.withPlugins (p: [ p.clean-css ])) ];
              base = writeText "base" ''
                @color: red;
                body {
                  h1 {
                    color: @color;
                  }
                }
              '';
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

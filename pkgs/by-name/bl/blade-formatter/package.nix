{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  writeText,
  runCommand,
  blade-formatter,
  nodejs,
}:

buildNpmPackage rec {
  pname = "blade-formatter";
  version = "1.41.1";

  src = fetchFromGitHub {
    owner = "shufo";
    repo = "blade-formatter";
    rev = "v${version}";
    hash = "sha256-iaWpIa+H+ocAXGc042PfmCu9UcJZeso9ripWB2/1oTs=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-wEz0DTbg+Fdmsf0Qyeu9QS+I8gkPJeaJC/3HuP913og=";

  passthru = {
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion {
        package = blade-formatter;
        command = "blade-formatter --version";
      };

      simple = testers.testEqualContents {
        assertion = "blade-formatter formats a basic blade file";
        expected = writeText "expected" ''
          @if (true)
              Hello world!
          @endif
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ blade-formatter ];
              base = writeText "base" ''
                @if(   true )  Hello world!   @endif
              '';
            }
            ''
              blade-formatter $base > $out
            '';
      };
    };
  };

  meta = {
    description = "Laravel Blade template formatter";
    homepage = "https://github.com/shufo/blade-formatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lelgenio ];
    mainProgram = "blade-formatter";
    inherit (nodejs.meta) platforms;
  };
}

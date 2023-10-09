{ lib
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, testers
, writeText
, runCommand
, blade-formatter
}:

mkYarnPackage rec {
  pname = "blade-formatter";
  version = "1.38.2";

  src = fetchFromGitHub {
    owner = "shufo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JvILLw7Yp4g/dSsYtZ2ylmlXfS9t+2KADlBrYOJWTpg=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-UFDxw3fYMzSUhZw+TCEh/dN7OioKI75LzKSnEwGPKDA=";
  };

  postBuild = "yarn build";

  passthru.tests = {
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
      actual = runCommand "actual"
        {
          nativeBuildInputs = [ blade-formatter ];
          base = writeText "base" ''
            @if(   true )  Hello world!   @endif
          '';
        } ''
        blade-formatter $base > $out
      '';
    };
  };

  meta = with lib; {
    description = "Laravel Blade template formatter";
    homepage = "https://github.com/shufo/blade-formatter";
    license = licenses.mit;
    maintainers = with maintainers; [ lelgenio ];
  };
}

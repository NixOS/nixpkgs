{ python3
, fetchFromGitHub
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      # https://github.com/domainaware/parsedmarc/issues/464
      msgraph-core = super.msgraph-core.overridePythonAttrs (old: rec {
        version = "0.2.2";

        src = fetchFromGitHub {
          owner = "microsoftgraph";
          repo = "msgraph-sdk-python-core";
          rev = "v${version}";
          hash = "sha256-eRRlG3GJX3WeKTNJVWgNTTHY56qiUGOlxtvEZ2xObLA=";
        };

        nativeBuildInputs = with self; [
          flit-core
        ];

        propagatedBuildInputs = with self; [
          requests
        ];

        nativeCheckInputs = with self; [
          pytestCheckHook
          responses
        ];

        disabledTestPaths = [
          "tests/integration"
        ];

        pythonImportsCheck = [ "msgraph.core" ];
      });
    };
  };
in with python.pkgs; toPythonApplication parsedmarc

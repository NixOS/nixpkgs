{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:

let
  python = python3.override {
    self = python3;
    packageOverrides = self: super: {
      pyrate-limiter = super.pyrate-limiter.overridePythonAttrs (oldAttrs: rec {
        version = "2.10.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = "v${version}";
          hash = "sha256-CPusPeyTS+QyWiMHsU0ii9ZxPuizsqv0wQy3uicrDw0=";
        };
        doCheck = false;
      });
    };
  };

in

python.pkgs.buildPythonApplication rec {
  pname = "conkeyscan";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CompassSecurity";
    repo = "conkeyscan";
    tag = "v${version}";
    hash = "sha256-xYCms+Su7FmaG7KVHZpzfD/wx9Gepz11t8dEK/YDfvI=";
  };

  patches = [
    # https://github.com/CompassSecurity/conkeyscan/pull/3
    (fetchpatch {
      name = "replace-random-user-agent-with-fake-useragent.patch";
      url = "https://github.com/nagapraneethk/conkeyscan/commit/f6cf61cc42fcc07930a06891b6c4a2653bfbf47f.patch";
      hash = "sha256-zfHU/KsgzQvn/kNsWZy1hGZaBHw/he1zDTUHHV/BHFc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  build-system = with python.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    atlassian-python-api
    beautifulsoup4
    clize
    loguru
    pysocks
    fake-useragent
    readchar
    requests-ratelimiter
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "conkeyscan" ];

  meta = {
    description = "Tool to scan Confluence for keywords";
    homepage = "https://github.com/CompassSecurity/conkeyscan";
    changelog = "https://github.com/CompassSecurity/conkeyscan/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "conkeyscan";
  };
}

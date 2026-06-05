{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "conkeyscan";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CompassSecurity";
    repo = "conkeyscan";
    tag = "v${finalAttrs.version}";
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
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${finalAttrs.version}"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
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
    changelog = "https://github.com/CompassSecurity/conkeyscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "conkeyscan";
  };
})

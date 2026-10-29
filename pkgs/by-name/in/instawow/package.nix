{
  lib,
  python3,
  fetchFromGitHub,
  plugins ? [ ],
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "instawow";
  version = "7.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = "instawow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nac3BWRvU0UKjNvwPAyklzRKkwtriony6cPns6tqyVk=";
  };

  # No .git dir available in nix build
  postPatch = ''
    cat >> pyproject.toml <<EOF

    [tool.versioningit]
    default-version = "${finalAttrs.version}"
    EOF
  '';

  # The versions available in nixpkgs don't match the ones requested exactly.
  pythonRelaxDeps = [
    "aiohttp"
    "rapidfuzz"
  ];

  extras = [ ]; # Disable GUI, most dependencies are not packaged.

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    versioningit
  ];
  propagatedBuildInputs =
    with python3.pkgs;
    [
      aiohttp
      aiohttp-client-cache
      attrs
      cattrs
      click
      diskcache
      loguru
      packaging
      pluggy
      prompt-toolkit
      rapidfuzz
      truststore
      typing-extensions
      wcwidth
      yarl
    ]
    ++ plugins;

  meta = {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ seirl ];
  };
})

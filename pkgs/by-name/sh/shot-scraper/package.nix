{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "shot-scraper";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "shot-scraper";
    tag = finalAttrs.version;
    hash = "sha256-HIiUZZz2/EqTdaCtiaqVaJfbRwkoYL8H6XHaIYP0R6M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.18,<0.10.0" "uv_build"
  '';

  build-system = with python3.pkgs; [ uv-build ];

  dependencies = with python3.pkgs; [
    click
    click-default-group
    playwright
    pyyaml
  ];

  # skip tests due to network access
  doCheck = false;

  pythonImportsCheck = [ "shot_scraper" ];

  meta = {
    description = "Command-line utility for taking automated screenshots of websites";
    homepage = "https://github.com/simonw/shot-scraper";
    changelog = "https://github.com/simonw/shot-scraper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
    mainProgram = "shot-scraper";
  };
})

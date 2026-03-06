{
  ansible-lint,
  bats,
  cmake-lint,
  cmake,
  fetchFromGitHub,
  lib,
  libxml2,
  libxslt,
  linkchecker,
  openscap,
  python3Packages,
  stdenv,
  shellcheck,
  yamllint,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scap-security-guide";
  version = "0.1.80";

  src = fetchFromGitHub {
    owner = "ComplianceAsCode";
    repo = "content";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1deyqjpXVL5HuksjS5N7GpG2WGSvj3wHi8cHaRgo458=";
  };

  postPatch = ''
    substituteInPlace build-scripts/generate_guides.py \
      --replace-fail "XCCDF_GUIDE_XSL = None" "XCCDF_GUIDE_XSL = \"${openscap}/share/openscap/xsl/xccdf-guide.xsl\""
  '';

  nativeBuildInputs =
    with python3Packages;
    [
      setuptools
      sphinx
      sphinxcontrib-jinjadomain
      sphinx-rtd-theme
      sphinx-jinja
    ]
    ++ [
      cmake-lint
      cmake
    ];

  buildInputs =
    with python3Packages;
    [
      ansible
      jinja2
      json2html
      myst-parser
      mypy
      openpyxl
      pygithub
      pyyaml
      pandas
      pycompliance
      prometheus-async
      ruamel-yaml
      voluptuous-stubs
      yamllint
    ]
    ++ [
      ansible-lint
      bats
      libxslt
      libxml2
      linkchecker
      openscap
      shellcheck
      yamllint
    ];

  meta = {
    description = "Security automation content in SCAP, Bash, Ansible, and other formats";
    homepage = "https://github.com/ComplianceAsCode/content";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tochiaha ];
    platforms = lib.platforms.all;
  };
})

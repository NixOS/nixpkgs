{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "glad";
  version = "2.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dav1dde";
    repo = "glad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aWqqOtNbaWMIKN1KAnXfTbDOgcZ87XaXwVGVgePzLDE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    jinja2
  ];

  # makeWrapperArgs = [
  #   "--add-flags"
  #   "--quiet"
  # ];

  __structuredAttrs = true;

  meta = {
    description = "Multi-Language Vulkan/GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs";
    homepage = "https://gen.glad.sh/";
    license =
      with lib.licenses;
      AND [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      nooneknowspeter
    ];
    mainProgram = "glad";
  };
})

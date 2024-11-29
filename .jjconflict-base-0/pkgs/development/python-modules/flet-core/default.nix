{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,

  # propagates
  typing-extensions,
  repath,
}:

buildPythonPackage rec {
  pname = "flet-core";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet-core";

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    repath
    typing-extensions
  ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    description = "Library is the foundation of Flet framework and is not intended to be used directly";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  cairo,
  pango,
  pkg-config,
  stdenv,
}:

buildNpmPackage rec {
  pname = "excalidraw_export";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Timmmm";
    repo = "excalidraw_export";
    rev = "320c8be92f468e5e19564f83e37709b80afc0e46";
    hash = "sha256-E5kYI8+hzObd2WNVBd0aQDKMH1Sns539loCQfClJs1Q=";
  };

  npmDepsHash = "sha256-5yec7BCi1c/e+y00TqxIeoazs49+WdKdfsskAqnVkFs=";

  npmBuildScript = "compile";

  buildInputs = [
    cairo
    pango
  ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "CLI to export Excalidraw drawings to SVG and PDF";
    homepage = "https://github.com/Timmmm/excalidraw_export";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ venikx ];
    mainProgram = "excalidraw_export";
    broken = stdenv.isDarwin;
  };
}

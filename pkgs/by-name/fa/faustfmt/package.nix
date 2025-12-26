{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "faustfmt";
  version = "0-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustfmt";
    rev = "93a897a08f034b9a73397b0052a3391fcdb28fe9";
    hash = "sha256-QZvzsWSrs5yXw7R89nz+hf/phdd6qBzp4CpjcnxbZEI=";
  };

  cargoHash = "sha256-uwBCy52juE3YcJoackhvrHjrvcoahbnDFg74p/X3ce8=";

  meta = {
    description = "Formatter for the Faust programming language, using Topiary";
    homepage = "https://github.com/grame-cncm/faustfmt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "faustfmt";
    platforms = lib.platforms.all;
  };
})

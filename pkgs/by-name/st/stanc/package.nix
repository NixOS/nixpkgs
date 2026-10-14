{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  versionCheckHook,
}:

ocamlPackages.buildDunePackage rec {
  pname = "stanc";
  version = "2.40.0";

  minimalOCamlVersion = "5.3";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "stanc3";
    tag = "v${version}";
    hash = "sha256-Xr7ulBens9qTVvkHwmGu/dDgXGInp7BJN13BKi/adko=";
  };

  postPatch = ''
    substituteInPlace src/driver/Entry.ml src/stanc/CLI.ml src/stan_math_backend/Lower_program.ml \
      --replace-fail '%%NAME%%' 'stanc' \
      --replace-fail '%%VERSION%%' 'v${version}'
  '';

  nativeBuildInputs = with ocamlPackages; [
    cmdliner
    menhir
  ];

  buildInputs = with ocamlPackages; [
    cmdliner
    fmt
    menhirLib
    ppx_compare
    ppx_deriving
    ppx_expect_nobase
    ppx_sexp_conv
    sexplib0
    yojson
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/stan-dev/stanc3";
    description = "Stan compiler and utilities";
    license = lib.licenses.bsd3;
    mainProgram = "stanc";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}

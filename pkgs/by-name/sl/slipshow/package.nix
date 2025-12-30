{
  lib,
  ocamlPackages,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

ocamlPackages.buildDunePackage rec {
  pname = "slipshow";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "panglesd";
    repo = "slipshow";
    tag = "v${version}";
    hash = "sha256-HV4qUp/da0GjZ/KSaE4L/qxdosnOTRcC83zIRigxFSY=";
  };

  postPatch = ''
    substituteInPlace ./src/cli/main.ml \
      --replace-fail '%%VERSION%%' '${version}'
  '';

  nativeBuildInputs = with ocamlPackages; [
    js_of_ocaml
  ];

  buildInputs = with ocamlPackages; [
    base64
    bos
    cmdliner
    dream
    fmt
    fpath
    irmin-watcher
    js_of_ocaml-lwt
    logs
    lwt
    magic-mime
    ppx_blob
    ppx_deriving_yojson
    ppx_sexp_value
    sexplib
  ];

  doCheck = true;

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) slipshow; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Engine for displaying slips, the next-gen version of slides";
    homepage = "https://slipshow.readthedocs.io/en/latest/index.html";
    license = lib.licenses.gpl3Only;
    downloadPage = "https://github.com/panglesd/slipshow";
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
    mainProgram = "slipshow";
  };
}

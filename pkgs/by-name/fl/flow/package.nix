{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml-ng,
  dune,
  versionCheckHook,
}:

let
  ocamlPackages = ocaml-ng.ocamlPackages.overrideScope (
    self: super: {
      ppxlib = super.ppxlib.override { version = "0.34.0"; };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flow";
  version = "0.299.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ohGqzTI0TW92lsM9fqJv8iRk3SZkKT03Ek+15Lj2RYU=";
  };

  patches = [
    # error: 'uint64_t' does not name a type
    ./gcc-15-compat.patch
  ];

  makeFlags = [ "FLOW_RELEASE=1" ];

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    dune
    findlib
    ocamlbuild
  ];

  buildInputs = (
    with ocamlPackages;
    [
      camlp-streams
      dtoa
      fileutils
      lwt_log
      lwt_ppx
      lwt
      ppx_deriving
      ppx_gen_rec
      ppx_let
      sedlex
      visitors
      wtf8
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify ]
  );

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Static type checker for JavaScript";
    mainProgram = "flow";
    homepage = "https://flow.org/";
    changelog = "https://github.com/facebook/flow/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with lib.maintainers; [ puffnfresh ];
  };
})

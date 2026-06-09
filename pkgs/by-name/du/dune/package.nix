{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  version ? "3.22.1",
}:
let
  # needed for pkgsStatic
  inherit (buildPackages.buildPackages) ocamlPackages;
in
stdenv.mkDerivation {
  pname = "dune";
  inherit version;

  src = fetchurl {
    url =
      let
        sfx = lib.optionalString (lib.versions.major version == "2") "site-";
      in
      "https://github.com/ocaml/dune/releases/download/${version}/dune-${sfx}${version}.tbz";
    hash =
      {
        "3.22.1" = "sha256:1za79mc2x2nwz45dlkad272pls7x4i02khn2hrl45v1jdhwrh2qc";
        "2.9.3" = "sha256:1ml8bxym8sdfz25bx947al7cvsi2zg5lcv7x9w6xb01cmdryqr9y";
      }
      ."${version}";
  };

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;
  __structuredAttrs = true;

  buildFlags = [ "release" ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=$(OCAMLFIND_DESTDIR)"
  ];

  passthru.tests = {
    inherit (ocamlPackages) ocaml-lsp dune-release;
  };

  meta = {
    homepage = "https://dune.build/";
    description = "Composable build system";
    mainProgram = "dune";
    changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}

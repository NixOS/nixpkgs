{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  version ? "3.24.0_alpha0",
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
        # Pre-release tarballs are named with a "." separator (dune-3.24.0.alpha0.tbz)
        # while the git tag uses "_" (3.24.0_alpha0).
        filenameVersion = builtins.replaceStrings [ "_" ] [ "." ] version;
      in
      "https://github.com/ocaml/dune/releases/download/${version}/dune-${sfx}${filenameVersion}.tbz";
    hash =
      {
        "3.24.0_alpha0" = "sha256-hH6Rhac4ehY+OahA8wC2A53CxXiHT72KH00LYUA3mFw=";
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

{ lib
, emacs
, f
, fetchFromGitHub
, markdown-mode
, rustPlatform
, trivialBuild
, yasnippet
}:

let
  version = "unstable-2024-04-18";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "4aa973b5d0d854d6ed8dba76e791ae4cf9416793";
    hash = "sha256-bhjW7t8wddz6VRGaa6fLAaA/mcn57BVBmEjbfcW4O7k=";
  };

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using rust";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.marsam ];
    inherit (emacs.meta) platforms;
  };

  lspce-module = rustPlatform.buildRustPackage {
    inherit version src meta;
    pname = "lspce-module";

    cargoHash = "sha256-HLYKebVzX9115crvMogbcUlt+r/DYz6CTKoZm0AQjmc=";

    checkFlags = [
      # flaky test
      "--skip=msg::tests::serialize_request_with_null_params"
    ];

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      for f in $out/lib/*; do
        mv $f $out/share/emacs/site-lisp/lspce-module.''${f##*.}
      done
      rmdir $out/lib
    '';
  };
in
trivialBuild rec {
  inherit version src meta;
  pname = "lspce";

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [
    f
    markdown-mode
    yasnippet
    lspce-module
  ];

  passthru = {
    inherit lspce-module;
  };
}

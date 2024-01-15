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
  version = "unstable-2023-12-01";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "1958b6fcdfb6288aa17fa42360315d6c4aa85991";
    hash = "sha256-HUIRm1z6xNJWgX7ykujzniBrOTh76D3dJHrm0LR3nuQ=";
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

    cargoHash = "sha256-qMLwdZwqrK7bPXL1bIbOqM7xQPpeiO8FDoje0CEJeXQ=";

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

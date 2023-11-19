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
  version = "unstable-2023-10-30";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "34c59787bcdbf414c92d9b3bf0a0f5306cb98d64";
    hash = "sha256-kUHGdeJo2zXA410FqXGclgXmgWrll30Zv8fSprcmnIo=";
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

    cargoHash = "sha256-eqSromwJrFhtJWedDVJivfbKpAtSFEtuCP098qOxFgI=";

    checkFlags = [
      # flaky test
      "--skip=msg::tests::serialize_request_with_null_params"
    ];

    postFixup = ''
      for f in $out/lib/*; do
        mv $f $out/lib/lspce-module.''${f##*.}
      done
    '';
  };
in
trivialBuild rec {
  inherit version src meta;
  pname = "lspce";

  preBuild = ''
    ln -s ${lspce-module}/lib/lspce-module* .

    # Fix byte-compilation
    substituteInPlace lspce-util.el \
      --replace "(require 'yasnippet)" "(require 'yasnippet)(require 'url-util)"
    substituteInPlace lspce-calltree.el \
      --replace "(require 'compile)" "(require 'compile)(require 'cl-lib)"
  '';

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [
    f
    markdown-mode
    yasnippet
  ];

  postInstall = ''
    install lspce-module* $LISPDIR
  '';
}

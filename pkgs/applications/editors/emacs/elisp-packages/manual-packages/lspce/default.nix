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
  version = "1.0.0-unstable-2024-02-03";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "543dcf0ea9e3ff5c142c4365d90b6ae8dc27bd15";
    hash = "sha256-LZWRQOKkTjNo8jecBRholW9SHpiK0SWcV8yObojpvxo=";
  };

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using rust";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    inherit (emacs.meta) platforms;
  };

  lspce-module = rustPlatform.buildRustPackage {
    inherit version src meta;
    pname = "lspce-module";

    cargoHash = "sha256-W9rsi7o4KvyRoG/pqRKOBbJtUoSW549Sh8+OV9sLcxs=";

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

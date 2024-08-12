{
  lib,
  f,
  fetchFromGitHub,
  markdown-mode,
  melpaBuild,
  nix-update-script,
  rustPlatform,
  yasnippet,
}:

let
  self = melpaBuild {
    pname = "lspce";
    version = "1.1.0-unstable-2024-08-04";

    src = fetchFromGitHub {
      owner = "zbelial";
      repo = "lspce";
      rev = "59b9c0551ee34440d3cc754313ac8076f7076f54";
      hash = "sha256-VpIsAteBEoENhejS0QqAZRoEYgaDpVCdPqrgrj4OcIU=";
    };

    lspce-module = rustPlatform.buildRustPackage {
      pname = "lspce-module";
      inherit (self) version src;

      cargoHash = "sha256-q0xUOzDRpiAdvtH3rzCOZRYthGR6MvbiXB4a7cDgf9A=";

      checkFlags = [
        # flaky test
        "--skip=msg::tests::serialize_request_with_null_params"
      ];

      # rename module without changing either suffix or location
      # use for loop because there seems to be two modules on darwin systems
      # https://github.com/zbelial/lspce/issues/7#issue-1783708570
      postInstall = ''
      for f in $out/lib/*; do
        mv --verbose $f $out/lib/lspce-module.''${f##*.}
      done
    '';
    };

    packageRequires = [
      f
      markdown-mode
      yasnippet
    ];

    # lspce-module.so is needed to compile lspce.el
    files = ''(:defaults "${lib.getLib self.lspce-module}/lib/lspce-module.*")'';

    passthru = {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    };

    meta = {
      homepage = "https://github.com/zbelial/lspce";
      description = "LSP Client for Emacs implemented as a module using Rust";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self


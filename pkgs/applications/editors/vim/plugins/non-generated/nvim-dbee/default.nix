{
  lib,
  buildGoModule,
  fetchFromGitHub,
  arrow-cpp,
  duckdb,
  nix-update-script,
  stdenv,
  vimPlugins,
  vimUtils,
}:
let
  version = "0.1.9";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    tag = "v${version}";
    hash = "sha256-AOime4vG0NFcUvsd9Iw5SxR7WaeCsoCRU6h5+vSkt4M=";
  };
  dbee-bin = buildGoModule {
    pname = "dbee-bin";
    inherit version;

    inherit src;
    sourceRoot = "${src.name}/dbee";

    vendorHash = "sha256-U/3WZJ/+Bm0ghjeNUILsnlZnjIwk3ySaX3Rd4L9Z62A=";
    buildInputs = [
      arrow-cpp
      duckdb
    ];

    # Tests attempt to access `/etc/protocols` which is forbidden in the sandbox
    doCheck = !stdenv.hostPlatform.isDarwin;

    meta.mainProgram = "dbee";
  };
in
vimUtils.buildVimPlugin {
  pname = "nvim-dbee";
  inherit version src;

  postPatch = ''
    substituteInPlace lua/dbee/install/init.lua \
      --replace-fail 'return vim.fn.stdpath("data") .. "/dbee/bin"' 'return "${dbee-bin}/bin"'
  '';

  preFixup = ''
    mkdir $target/bin
    ln -s ${lib.getExe dbee-bin} $target/bin/dbee
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.nvim-dbee.dbee-bin";
    };

    # needed for the update script
    inherit dbee-bin;
  };

  dependencies = [ vimPlugins.nui-nvim ];

  meta = {
    description = "Interactive database client for neovim";
    homepage = "https://github.com/kndndrj/nvim-dbee";
    changelog = "https://github.com/kndndrj/nvim-dbee/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ perchun ];
  };
}

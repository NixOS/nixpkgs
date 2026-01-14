{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libuv,
  openssl,
  vimUtils,
  nix-update-script,
}:
let
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "codesnap.nvim";
    tag = "v${version}";
    hash = "sha256-gpsNug6lSc/AifW8DeJy9R3LYuiTStuYZV02MiIZhq8=";
  };
  codesnap-lib = rustPlatform.buildRustPackage {
    pname = "codesnap-lib";
    inherit version src;

    sourceRoot = "${src.name}/generator";

    cargoHash = "sha256-tV0Mi+SgdVWkY0fSQ3ZfQnHa8mM8f/49Zy8iv94qBjA=";

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    env = {
      # Use system openssl
      OPENSSL_NO_VENDOR = 1;

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };

    postInstall = ''
      echo "${version}" > $out/lib/.version
    '';

    buildInputs = [
      libuv.dev
      openssl
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "codesnap.nvim";
  inherit version src;

  postPatch =
    let
      extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
    in
    ''
      substituteInPlace lua/codesnap/fetch.lua \
        --replace-fail \
          "local lib_name = get_platform_lib_name()" \
          "local lib_name = 'libgenerator.${extension}'" \
        --replace-fail \
          'local lib_dir = path_utils.join(sep, vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h"), "libs")' \
          'local lib_dir = "${codesnap-lib}/lib"'
    '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.codesnap-nvim.codesnap-lib";
    };

    # needed for the update script
    inherit codesnap-lib;
  };

  meta = {
    homepage = "https://github.com/mistricky/codesnap.nvim/";
    changelog = "https://github.com/mistricky/codesnap.nvim/releases/tag/${src.tag}";
    license = lib.licenses.mit;
  };
}

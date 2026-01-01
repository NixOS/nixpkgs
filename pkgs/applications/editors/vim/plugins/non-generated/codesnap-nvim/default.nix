{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  rustPlatform,
  pkg-config,
  libuv,
  openssl,
  vimUtils,
  nix-update-script,
}:
let
  version = "2.0.0";
=======
  nix-update-script,
  pkg-config,
  rustPlatform,
  vimUtils,
  libuv,
}:
let
  version = "1.6.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "codesnap.nvim";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gpsNug6lSc/AifW8DeJy9R3LYuiTStuYZV02MiIZhq8=";
=======
    hash = "sha256-VHH1jQczzNFiH+5YflhU9vVCkEUoKciV/Z/n9DEZwiY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  codesnap-lib = rustPlatform.buildRustPackage {
    pname = "codesnap-lib";
    inherit version src;

    sourceRoot = "${src.name}/generator";

<<<<<<< HEAD
    cargoHash = "sha256-tV0Mi+SgdVWkY0fSQ3ZfQnHa8mM8f/49Zy8iv94qBjA=";
=======
    cargoHash = "sha256-tg4BO4tPzHhJTowL7RiAuBo4i440FehpGmnz9stTxfI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

<<<<<<< HEAD
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
=======
    # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
    env.RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";

    buildInputs = [
      libuv.dev
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "codesnap.nvim";
  inherit version src;

<<<<<<< HEAD
  postPatch =
=======
  # - Remove the shipped pre-built binaries
  # - Copy the resulting binary from the codesnap-lib derivation
  # Note: the destination should be generator.so, even on darwin
  # https://github.com/mistricky/codesnap.nvim/blob/main/scripts/build_generator.sh
  postInstall =
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    let
      extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
    in
    ''
<<<<<<< HEAD
      substituteInPlace lua/codesnap/fetch.lua \
        --replace-fail \
          "local lib_name = get_platform_lib_name()" \
          "local lib_name = 'libgenerator.${extension}'" \
        --replace-fail \
          'local lib_dir = path_utils.join(sep, vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h"), "libs")' \
          'local lib_dir = "${codesnap-lib}/lib"'
=======
      rm -r $out/lua/*.so
      cp ${codesnap-lib}/lib/libgenerator.${extension} $out/lua/generator.so
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

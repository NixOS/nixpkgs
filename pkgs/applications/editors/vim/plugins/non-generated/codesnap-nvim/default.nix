{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  vimUtils,
  libuv,
}:
let
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "codesnap.nvim";
    tag = "v${version}";
    hash = "sha256-OmSgrTYDtNb2plMyzjVvxGrfXB/lGKDpUQhpRqKfAMA=";
  };
  codesnap-lib = rustPlatform.buildRustPackage {
    pname = "codesnap-lib";
    inherit version src;

    sourceRoot = "${src.name}/generator";

    cargoHash = "sha256-6n37n8oHIHrz3S1+40nuD0Ud3l0iNgXig1ZwrgsnYTI=";

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      libuv.dev
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "codesnap.nvim";
  inherit version src;

  # - Remove the shipped pre-built binaries
  # - Copy the resulting binary from the codesnap-lib derivation
  # Note: the destination should be generator.so, even on darwin
  # https://github.com/mistricky/codesnap.nvim/blob/main/scripts/build_generator.sh
  postInstall =
    let
      extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
    in
    ''
      rm -r $out/lua/*.so
      cp ${codesnap-lib}/lib/libgenerator.${extension} $out/lua/generator.so
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

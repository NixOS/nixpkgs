{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    tag = "v${version}";
    hash = "sha256-rA3R9SO3QRLGBVHlT5NZLtQw+EmkkmSDO/K6DdNtfBI=";
  };
  extension = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  cord-nvim-rust = rustPlatform.buildRustPackage {
    pname = "cord.nvim-rust";
    inherit version src;

    useFetchCargoVendor = true;
    cargoHash = "sha256-UJdSQNaYaZxvmfuHwePzGhQ3Pv+Cm7YaRK1L0CJhtEc=";

    installPhase =
      let
        cargoTarget = stdenv.hostPlatform.rust.cargoShortTarget;
      in
      ''
        install -D target/${cargoTarget}/release/libcord.${extension} $out/lib/cord.${extension}
      '';
  };
in
vimUtils.buildVimPlugin {
  pname = "cord.nvim";
  inherit version src;

  nativeBuildInputs = [
    cord-nvim-rust
  ];

  buildPhase = ''
    runHook preBuild

    install -D ${cord-nvim-rust}/lib/cord.${extension} cord.${extension}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D cord $out/lua/cord.${extension}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.cord-nvim.cord-nvim-rust";
    };

    # needed for the update script
    inherit cord-nvim-rust;
  };

  meta = {
    homepage = "https://github.com/vyfor/cord.nvim";
    license = lib.licenses.asl20;
  };
}

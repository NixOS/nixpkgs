{
  fetchFromGitHub,
  jujutsu,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  vimUtils,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "Yuki-bun";
    repo = "kenjutu";
    tag = "kjn/v${version}";
    hash = "sha256-Ogf8B/h8RZozeZH20YPFs7+3kBWduRuNOkwiKpj+8Hc=";
  };

  kjn-rust = rustPlatform.buildRustPackage {
    pname = "kenjutu-kjn";
    inherit version src;
    cargoHash = "sha256-eND52/L3kPuuqND7fF7eiOs0nWikFWcGDT2eG2m6+Ho=";

    __structuredAttrs = true;

    # As this is a monorepo, building everything results in unneeded/unwanted dependencies.
    cargoBuildFlags = [
      "-p"
      "kenjutu-nvim"
    ];
    cargoTestFlags = [
      "-p"
      "kenjutu-nvim"
    ];

    buildInputs = [ openssl ];
    nativeBuildInputs = [
      makeBinaryWrapper
      pkg-config
      writableTmpDirAsHomeHook
    ];
    # A requirement to execute the tests, as this tool uses it as a dependency by default
    nativeCheckInputs = [ jujutsu ];

    nativeInstallCheckInputs = [
      versionCheckHook
    ];

    doInstallCheck = true;

    postInstall = ''
      wrapProgram $out/bin/kjn --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
    '';

    meta = {
      license = lib.licenses.asl20;
      mainProgram = "kjn";
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "kenjutu-nvim";
  inherit version src;

  dependencies = [ kjn-rust ];
  postInstall = ''
    mkdir -p $out/bin
    ln -s ${lib.getExe kjn-rust} $out/bin/kjn
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.kenjutu-nvim.kjn-rust";
    };

    # needed for the update script
    inherit kjn-rust;
  };

  meta = {
    changelog = "https://github.com/Yuki-bun/kenjutu/releases/tag/${src.tag}";
    description = "Track your code review progress hunk-by-hunk through history rewrites for jj users";
    homepage = "https://github.com/Yuki-bun/kenjutu/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      daneov
    ];
  };
}

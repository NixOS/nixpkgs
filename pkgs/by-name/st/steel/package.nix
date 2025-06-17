{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  makeBinaryWrapper,
  installShellFiles,
  libgit2,
  oniguruma,
  openssl,
  sqlite,
  zlib,

  nix-update-script,
  includeLSP ? true,
  includeForge ? true,
}:
rustPlatform.buildRustPackage {
  pname = "steel";
  version = "0-unstable-2025-06-15";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "steel";
    rev = "123adb314702d6520f8ab04115e79308d2400c38";
    hash = "sha256-o1RZBlAGUht0Q7UVF+yPlrWW7B016fpBBcoaxuzRQo4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/vPDVVOhLO7mnULyU8QLW+YHh+kGd+BSiPi55jrOWps=";

  nativeBuildInputs = [
    curl
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    curl
    libgit2
    oniguruma
    openssl
    sqlite
    zlib
  ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags =
    [
      "--package"
      "steel-interpreter"
      "--package"
      "cargo-steel-lib"
    ]
    ++ lib.optionals includeLSP [
      "--package"
      "steel-language-server"
    ]
    ++ lib.optionals includeForge [
      "--package"
      "forge"
    ];

  # Tests are disabled since they always fail when building with Nix
  doCheck = false;

  postInstall =
    ''
      mkdir -p $out/lib/steel

      substituteInPlace cogs/installer/download.scm \
        --replace-fail '"cargo-steel-lib"' '"$out/bin/cargo-steel-lib"'

      pushd cogs
      $out/bin/steel install.scm
      popd

      mv $out/lib/steel/bin/repl-connect $out/bin
      rm -rf $out/lib/steel/bin
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd steel \
        --bash <($out/bin/steel completions bash) \
        --fish <($out/bin/steel completions fish) \
        --zsh <($out/bin/steel completions zsh)
    '';

  postFixup = ''
    wrapProgram $out/bin/steel --set-default STEEL_HOME "$out/lib/steel"
  '';

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    STEEL_HOME = "${placeholder "out"}/lib/steel";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Embedded scheme interpreter in Rust";
    homepage = "https://github.com/mattwparas/steel";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "steel";
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}

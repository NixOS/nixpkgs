{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  makeBinaryWrapper,
  libgit2,
  oniguruma,
  openssl,
  sqlite,
  zlib,
  darwin,

  unstableGitUpdater,
  writeShellScript,
  yq,

  includeLSP ? true,
  includeForge ? true,
}:
rustPlatform.buildRustPackage {
  pname = "steel";
  version = "0.6.0-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "steel";
    rev = "2ec5e814f38ba9de1a8cc51d581d5226c4db1a49";
    hash = "sha256-WW2dsHJynFjQY2lMbUbQQIBPLbPNKj3nrnM362eeMbc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8S/CJFXv89lS3Gyd/TgHUrMxmvYQZvbXCiPQcQtL3Jo=";

  nativeBuildInputs = [
    curl
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    curl
    libgit2
    oniguruma
    openssl
    sqlite
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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

  postInstall = ''
    mkdir -p $out/lib/steel

    substituteInPlace cogs/installer/download.scm \
      --replace-fail '"cargo-steel-lib"' '"$out/bin/cargo-steel-lib"'

    pushd cogs
    $out/bin/steel install.scm
    popd

    mv $out/lib/steel/bin/repl-connect $out/bin
    rm -rf $out/lib/steel/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/steel --set-default STEEL_HOME "$out/lib/steel"
  '';

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    STEEL_HOME = "${placeholder "out"}/lib/steel";
  };

  passthru.updateScript = unstableGitUpdater {
    tagConverter = writeShellScript "steel-tagConverter.sh" ''
      export PATH="${
        lib.makeBinPath [
          curl
          yq
        ]
      }:$PATH"

      version=$(curl -s https://raw.githubusercontent.com/mattwparas/steel/refs/heads/master/Cargo.toml | tomlq -r .workspace.package.version)

      read -r tag
      test "$tag" = "0" && tag="$version"; echo "$tag"
    '';
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

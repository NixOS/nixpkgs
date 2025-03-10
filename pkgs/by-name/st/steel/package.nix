{
  lib,
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

  unstableGitUpdater,
  writeShellScript,
  yq,

  includeLSP ? true,
  includeForge ? true,
}:
rustPlatform.buildRustPackage {
  pname = "steel";
  version = "0.6.0-unstable-2025-02-27";

  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "steel";
    rev = "f1a605a0f3fe321f4605a80c4497eda2eac5ffce";
    hash = "sha256-3Iqoy2J9wY3T5jOSjtEk1aT+Q3ncNmmpQ/LY/iyvKuY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PWE64CwHCQWvOGeOqdsqX6rAruWlnCwsQpcxS221M3g=";

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

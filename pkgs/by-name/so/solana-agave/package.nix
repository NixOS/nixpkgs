{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  apple-sdk_11,
  libssl,
  libz,
  protobuf,
  cmake,
  gnumake,
  clang,
  llvm,
  llvmPackages,

  # withPCRE2 ? true,
  # pcre2,
}:

let
  canRun = stdenv.hostPlatform.emulatorAvailable buildPackages;
  agave = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/agave";
in
rustPlatform.buildRustPackage rec {
  pname = "solana-agave";
  version = "2.1.16";

  src = fetchFromGitHub {
    owner = "anza";
    repo = "agave";
    rev = version;
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [ installShellFiles protobuf cmake gnumake clang llvm llvmPackages.bintools ] ++ lib.optional withPCRE2 pkg-config;
  buildInputs =
    [ libssl libz pkg-config ]
    # ++ lib.optional withPCRE2 pcre2
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  # buildFeatures = lib.optional withPCRE2 "pcre2";

  preFixup = lib.optionalString canRun ''
    ${agave} --generate man > agave.1
    installManPage agave.1

    installShellCompletion --cmd agave \
      --bash <(${agave} --generate complete-bash) \
      --fish <(${agave} --generate complete-fish) \
      --zsh <(${agave} --generate complete-zsh)
  '';

  doInstallCheck = false;

  meta = with lib; {
    description = "Solana Network Validator";
    homepage = "https://github.com/anza-xyz/agave";
    changelog = "https://github.com/anza-xyz/agave/releases/tag/${version}";
    license = with licenses; [
      asl20
    ];
    maintainers = with maintainers; [
        TomMD
    ];
    mainProgram = "agave";
  };
}

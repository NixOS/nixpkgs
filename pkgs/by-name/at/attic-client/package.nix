{ lib
, rustPlatform
, fetchFromGitHub
, nix
, boost
, pkg-config
, stdenv
, installShellFiles
, darwin
, crates ? [ "attic-client" ]
}:
rustPlatform.buildRustPackage {
  pname = "attic";
  version = "0-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "61ebdef2e263c091f24807b07701be5cb8068dea";
    hash = "sha256-whgxjoDF7aey3xWy2b9Dp+NHsszK6By+raEbygcSU6w=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    nix
    boost
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    SystemConfiguration
  ]);

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  cargoBuildFlags = lib.concatMapStrings (c: "-p ${c} ") crates;

  ATTIC_DISTRIBUTOR = "nixpkgs";
  NIX_INCLUDE_PATH = "${lib.getDev nix}/include";

  # Attic interacts with Nix directly and its tests require trusted-user access
  # to nix-daemon to import NARs, which is not possible in the build sandbox.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    if [[ -f $out/bin/attic ]]; then
      installShellCompletion --cmd attic \
        --bash <($out/bin/attic gen-completions bash) \
        --zsh <($out/bin/attic gen-completions zsh) \
        --fish <($out/bin/attic gen-completions fish)
    fi
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Multi-tenant Nix Binary Cache";
    homepage = "https://github.com/zhaofengli/attic";
    license = licenses.asl20;
    maintainers = with maintainers; [ zhaofengli aciceri ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "attic";
  };
}

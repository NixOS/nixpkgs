{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  pkg-config,
  zstd,
  stdenv,
  darwin,
  gitMinimal,
}:

let
  inherit (darwin) libresolv;
in
rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = "onefetch";
    rev = version;
    hash = "sha256-Q74iqCSH8sdGFWC5DmMZhvUoL/Hzz4XNj548Gls6Hzk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BpWc1GEj94vGEXDJEyocItggP1vQC441wp8r3DwalFw=";

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ zstd ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libresolv
    ];

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    git init
    git config user.name nixbld
    git config user.email nixbld@example.com
    git add .
    git commit -m test
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd onefetch \
      --bash <($out/bin/onefetch --generate bash) \
      --fish <($out/bin/onefetch --generate fish) \
      --zsh <($out/bin/onefetch --generate zsh)
  '';

  meta = {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    changelog = "https://github.com/o2sh/onefetch/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      figsoda
      kloenk
    ];
    mainProgram = "onefetch";
  };
}

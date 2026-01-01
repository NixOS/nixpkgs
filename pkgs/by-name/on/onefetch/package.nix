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
<<<<<<< HEAD
  version = "2.26.1";
=======
  version = "2.25.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = "onefetch";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-JT7iQRKOK/2Zh/IDMv1FM1szITeBaaMy+WuXHjpPkfY=";
  };

  cargoHash = "sha256-VBbiOA/+SPcIvmhNQ71gUBOIWEWV1A86rljBfdAfhZM=";
=======
    hash = "sha256-ZaaSuHWkhJx0q1CBAiRhwoLeeyyoAj6/vP3AJwybjAo=";
  };

  cargoHash = "sha256-56Net4nNRndePhdsQPbmqiPHpOUGMmnQt6BuplQpvSU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    zstd
  ]
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
<<<<<<< HEAD
=======
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kloenk
    ];
    mainProgram = "onefetch";
  };
}

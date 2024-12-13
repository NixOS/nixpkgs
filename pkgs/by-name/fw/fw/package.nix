{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-fG1N/3Er7BvXOJTMGooaIMa5I9iNwnH+1om2jcWkI68=";
  };

  cargoHash = "sha256-1d2uX/A1HZAmAI3d0iet1NkG0IFuJpVnhWxpY0jVVUI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fw";
  };
}

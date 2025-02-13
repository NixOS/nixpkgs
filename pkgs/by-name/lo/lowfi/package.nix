{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "lowfi";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = version;
    hash = "sha256-lR22UN9LiuJknq2KTNOXcybXwi2KvLRe0KHocFWL0GM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xMksujaZgOPJsBiv6//4zeiUcWEV2Pc7daBaPUh3cYc=";

  buildFeatures = [ "mpris" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Extremely simple lofi player";
    homepage = "https://github.com/talwat/lowfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zsenai ];
    mainProgram = "lowfi";
  };
}

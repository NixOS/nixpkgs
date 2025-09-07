{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "amber";
    tag = "v${version}";
    sha256 = "sha256-q0o2PQngbDLumck27V0bIiB35zesn55Y+MwK2GjNVWo=";
  };

  cargoHash = "sha256-UFuWD3phcKuayQITd85Sou4ygDBMzjrR39vWrlseYJQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = with lib; {
    description = "Code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}

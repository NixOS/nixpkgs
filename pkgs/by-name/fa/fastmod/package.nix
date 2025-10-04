{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fastmod";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fastmod";
    rev = "v${version}";
    sha256 = "sha256-A/3vzfwaStoQ9gdNM8yjmL2J/pQjj6yb68WThiTF+1E=";
  };

  cargoHash = "sha256-GpV7F0TQyIRowY8LqLTVuwJcRYyyu055+g7BmxT4TMQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = with lib; {
    description = "Utility that makes sweeping changes to large, shared code bases";
    mainProgram = "fastmod";
    homepage = "https://github.com/facebookincubator/fastmod";
    license = licenses.asl20;
    maintainers = with maintainers; [ jduan ];
  };
}

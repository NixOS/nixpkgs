{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.10.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3xFJ7v/IZQ3yfU0D09sFXV+4XKRau+Mj3BNxkeUjbbU=";
  };

  cargoHash = "sha256-3Sw/USfGJuf6JGSR3Xkjnmm/UR7NK8rB8St48b4WpIM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    changelog = "https://github.com/zineland/zine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}

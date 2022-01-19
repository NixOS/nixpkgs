{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, stdenv
, libiconv
, Security
, SystemConfiguration
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "sha256-04LtnEq+GVz87RRXasZrC0Vy0BjTEgW1p6beVP/4Ab8=";
  };

  cargoSha256 = "sha256-qko4Ov0HrNr4FRdVtz5B+GMOi/z1BKG03ao/DmMDz4U=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  postInstall =
  ''
  mv $out/bin/giop $out/bin/gix
  mv $out/bin/gio $out/bin/ein
  '';
  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    changelog = "https://github.com/Byron/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ syberant ];
  };
}

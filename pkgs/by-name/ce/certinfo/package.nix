{
  stdenv,
  lib,
  buildGo123Module,
  fetchFromGitHub,
  libX11,
  darwin,
}:

buildGo123Module rec {
  pname = "certinfo";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${version}";
    sha256 = "sha256-BI5gYWKGMU0wLvnArG41bLWj+9ipe/GARKRX0fwz4ag=";
  };

  # clipboard functionality not working on Darwin
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  vendorHash = null;

  meta = with lib; {
    description = "Print x509 certificate info";
    mainProgram = "certinfo";
    homepage = "https://github.com/pete911/certinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ jakuzure ];
  };
}

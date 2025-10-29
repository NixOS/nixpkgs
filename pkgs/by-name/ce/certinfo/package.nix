{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
}:

buildGoModule rec {
  pname = "certinfo";
  version = "1.0.38";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${version}";
    sha256 = "sha256-3CAl/Kf20JMcq7aLOviwxpHkYXnOd2WXqC8o2TLEXGY=";
  };

  # clipboard functionality not working on Darwin
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libX11 ];

  vendorHash = null;

  meta = with lib; {
    description = "Print x509 certificate info";
    mainProgram = "certinfo";
    homepage = "https://github.com/pete911/certinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ jakuzure ];
  };
}

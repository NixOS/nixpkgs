{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "numr";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${version}";
    hash = "sha256-tDQxDU/CrzZvXjsVSkUtDHX53WddFt6G8RBrHd8mXyg=";
  };

  cargoHash = "sha256-4Ig35ev3L2Sr8m4JsQVv/3lSLDc9RxSFMYeI+N+Wg7A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  meta = with lib; {
    description = "Text calculator inspired by Numi - natural language expressions, variables, unit conversions";
    homepage = "https://github.com/nasedkinpv/numr";
    license = licenses.mit;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
    mainProgram = "numr";
  };
}

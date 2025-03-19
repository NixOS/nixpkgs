{
  lib,
  stdenv,
  fetchFromGitHub,
  babashka,
}:

stdenv.mkDerivation rec {
  pname = "keylight-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "versality";
    repo = "keylight-cli";
    tag = "v${version}";
    sha256 = "sha256-gzTvMBa7JVckxLnltlR5XOj6BBbfPXZei7Wj3f1n4Kw=";
  };

  buildInputs = [ babashka ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 keylight.bb $out/bin/keylight

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool to control Elgato Key Light devices";
    homepage = "https://github.com/versality/keylight-cli";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ versality ];
    mainProgram = "keylight";
    platforms = platforms.all;
  };
}

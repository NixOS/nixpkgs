{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, alass
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N+3KyBlLG90C3D5ivgj6qedtKsUBoBHr89gmxyAIfVI=";
  };

  cargoSha256 = "sha256-rjhSosiLIgcSw6OHpFmGNHXGUdf2QsiIXFVgtO9qNY0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/sub-batch" --prefix PATH : "${lib.makeBinPath [ alass ]}"
  '';

  meta = with lib; {
    description = "Match and rename subtitle files to video files and perform other batch operations on subtitle files";
    homepage = "https://github.com/kl/sub-batch";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
    broken = stdenv.isDarwin;
  };
}

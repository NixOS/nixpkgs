{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, alass
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "kl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WUW+lOGbZ82NJxmW+Ogxslf3COOp62aZ/08Yn26l4T0=";
  };

  cargoSha256 = "sha256-m9nBubmuuOcJyegmYGJizY/2b7oamBHKFNIaxOtikcA=";

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

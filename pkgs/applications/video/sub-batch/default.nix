{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, alass
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5fDnSmnnVB1RGrNrnmp40OGFF+OAhppnhOjVgnYxXr0=";
  };

  cargoSha256 = "sha256-cj1htJcUPCeYbP0t15UcMv4WQAG7tUROb97v4rUeMvU=";

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

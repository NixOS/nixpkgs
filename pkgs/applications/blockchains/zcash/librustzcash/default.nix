{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "librustzcash-unstable";
  version = "2018-10-27";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "librustzcash";
    rev = "06da3b9ac8f278e5d4ae13088cf0a4c03d2c13f5";
    sha256 = "0md0pp3k97iv7kfjpfkg14pjanhrql4vafa8ggbxpkajv1j4xldv";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "166v8cxlpfslbs5gljbh7wp0lxqakayw47ikxm9r9a39n7j36mq1";

  installPhase = ''
    mkdir -p $out/lib
    cp target/release/librustzcash.a $out/lib/
    mkdir -p $out/include
    cp librustzcash/include/librustzcash.h $out/include/
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Rust-language assets for Zcash";
    homepage = https://github.com/zcash/librustzcash;
    maintainers = with maintainers; [ rht tkerber ];
    license = with licenses; [ mit asl20 ];
    platforms = platforms.unix;
  };
}

{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "librustzcash-unstable-${version}";
  version = "2017-03-17";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "librustzcash";
    rev = "91348647a86201a9482ad4ad68398152dc3d635e";
    sha256 = "02l1f46frpvw1r6k1wfh77mrsnmsdvifqx0vnscxz4xgb9ia9d1c";
  };

  cargoSha256 = "1b0kal53ggcr59hbrsdj8fifjycahrmzwq677n9h3fywv4r237m6";

  installPhase = ''
    mkdir -p $out/lib
    cp target/release/librustzcash.a $out/lib/
    mkdir -p $out/include
    cp include/librustzcash.h $out/include/
  '';

  meta = with stdenv.lib; {
    description = "Rust-language assets for Zcash";
    homepage = https://github.com/zcash/librustzcash;
    maintainers = with maintainers; [ rht ];
    license = with licenses; [ mit asl20 ];
    platforms = platforms.unix;
  };
}

{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "librustzcash";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "librustzcash";
    rev = version;
    sha256 = "0d28k29sgzrg9clynz29kpw50kbkp0a4dfdayqhmpjmsh05y6261";
  };

  cargoSha256 = "1wzyrcmcbrna6rjzw19c4lq30didzk4w6fs6wmvxp0xfg4qqdlax";

  installPhase = ''
    mkdir -p $out/lib
    cp target/release/librustzcash.a $out/lib/
    mkdir -p $out/include
    cp librustzcash/include/librustzcash.h $out/include/
  '';

  # The tests do pass, but they take an extremely long time to run.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Rust-language assets for Zcash";
    homepage = "https://github.com/zcash/librustzcash";
    maintainers = with maintainers; [ rht tkerber ];
    license = with licenses; [ mit asl20 ];
    platforms = platforms.unix;
  };
}

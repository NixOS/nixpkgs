{ stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "imag";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "matthiasbeyer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rkl4n3x2dk9x7705zsqjlxh92w7k6jkc27zqf18pwfl3fzz8f8p";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "11l38wx5hi8a6gk4biqr11i05b0aa3mjphmzh6b8np9ghn0iym58";

  checkPhase = ''
    cargo test -- \
    --skip test_linking
  '';

  meta = with stdenv.lib; {
    description = "Commandline personal information management suite";
    homepage = "https://imag-pim.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}

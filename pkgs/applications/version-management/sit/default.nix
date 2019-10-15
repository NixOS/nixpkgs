{ stdenv, fetchFromGitHub, rustPlatform, cmake, libzip, gnupg, 
  # Darwin
  libiconv, CoreFoundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "sit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sit-fyi";
    repo = "sit";
    rev = "v${version}";
    sha256 = "06xkhlfix0h6di6cnvc4blbj3mjy90scbh89dvywbx16wjlc79pf";
  };

  buildInputs = [ cmake libzip gnupg ] ++
    (if stdenv.isDarwin then [ libiconv CoreFoundation Security ] else []);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  cargoSha256 = "0kijx7s7zh6yisrsjz213h9x5jx43ixr44vy5rb3wwbn9dgsr528";

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = https://sit.fyi/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir yrashk ];
    platforms = platforms.all;
  };
}

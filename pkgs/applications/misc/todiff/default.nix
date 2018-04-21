{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "todiff-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    sha256 = "0n3sifinwhny651q1v1a6y9ybim1b0nd5s1z26sigjdhdvxckn65";
  };

  cargoSha256 = "0mxdpn98fvmxrp656vwxvzl9vprz5mvqj7d1hvvs4gsjrsiyp0fy";

  meta = with stdenv.lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}

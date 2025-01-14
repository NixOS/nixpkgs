{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "slowhttptest";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "shekyan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rIvd3LykVAbDXtFWZ1EQ+QKeALzqwK6pq7In0BsCOFo=";
  };

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Application Layer DoS attack simulator";
    homepage = "https://github.com/shekyan/slowhttptest";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "slowhttptest";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slowhttptest";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "shekyan";
    repo = "slowhttptest";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rIvd3LykVAbDXtFWZ1EQ+QKeALzqwK6pq7In0BsCOFo=";
  };

  buildInputs = [ openssl ];

  meta = {
    description = "Application Layer DoS attack simulator";
    homepage = "https://github.com/shekyan/slowhttptest";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "slowhttptest";
  };
})

{ darwin, fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  name = "click-${version}";
  version = "0.3.1";
  rev = "b5dfb4a8f8344330a098cb61523695dfe0fd296a";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "click";
    sha256 = "0a2hq4hcxkkx7gs5dv7sr3j5jy2dby4r6y090z7zl2xy5wydr7bi";
    inherit rev;
  };

  cargoSha256 = "03vgbkv9xsnx44vivbbhjgxv9drp0yjnimgy6hwm32x74r00k3hj";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with stdenv.lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = https://github.com/databricks/click;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

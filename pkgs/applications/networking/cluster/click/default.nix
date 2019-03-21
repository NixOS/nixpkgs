{ darwin, fetchFromGitHub, rustPlatform, stdenv }:

with rustPlatform;

buildRustPackage rec {
  name = "click-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "databricks";
    repo = "click";
    sha256 = "0sbj41kypn637z1w115w2h5v6bxz3y6w5ikgpx3ihsh89lkc19d2";
  };

  cargoSha256 = "05asqp5312a1g26pvf5hgqhc4kj3iw2hdvml2ycvga33sxb7zm7r";

  patches = [ ./fix_cargo_lock_version.patch ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with stdenv.lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = https://github.com/databricks/click;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

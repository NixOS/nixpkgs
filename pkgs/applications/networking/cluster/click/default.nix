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

  cargoSha256 = "1179a17lfr3001vp1a2adbkhdm9677n56af2c0zvkr18jas6b2w7";

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

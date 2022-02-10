{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage {
  pname = "nuget2nix";
  version = "unstable-2022-02-08";

  src = fetchFromGitHub {
    owner = "winterqt";
    repo = "nuget2nix";
    rev = "d9a28389d93e153047e517738671c9efe35dbd24";
    sha256 = "0czw20nwjbw719zvznlyls01qzshlcljfg8qfxwxf1w0rpwnbmj8";
  };

  cargoSha256 = "0jd2m372xwl1hdvqgjjhwp52i04gfs0ga7bip538flr4m5b09504";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Generates a Nix expression for `buildDotnetModule`";
    homepage = "https://github.com/winterqt/nuget2nix";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
    platforms = platforms.all;
  };
}

{ lib, rustPlatform, fetchFromGitHub, jq }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mw6mPOxiWnYu2QgqL4VccwwJhdxZ7zLJyX/oJWfGUhw=";
  };

  cargoSha256 = "sha256-ygQklcRjdffGl0s77MwKsyHVJWqWJZHq4SU38cSMVug=";

  depsExtraArgs = {
    nativeBuildInputs = [ jq ];
    postBuild = ''
      pushd $name/humansize

      [ -d feature-tests ] && rm -r feature-tests

      jq '.files |= with_entries(select(.key | startswith("feature-tests") | not))' \
        -c .cargo-checksum.json > .cargo-checksum.json.new
      mv .cargo-checksum.json{.new,}

      popd
    '';
  };

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

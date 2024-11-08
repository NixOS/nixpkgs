{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "semver";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catouc";
    repo = "semver-go";
    rev = "v${version}";
    sha256 = "0v3j7rw917wnmp4lyjscqzk4qf4azfiz70ynbq3wl4gwp1m783vv";
  };

  vendorHash = null;
  nativeBuildInputs = [ git ];

  meta = with lib; {
    homepage = "https://github.com/catouc/semver-go";
    description = "Small CLI to fish out the current or next semver version from a git repository";
    maintainers = with maintainers; [ catouc ];
    license = licenses.mit;
    mainProgram = "semver";
  };
}

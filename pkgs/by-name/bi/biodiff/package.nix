{
  lib,
  fetchFromGitHub,
  rustPlatform,
  wfa2-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "biodiff";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "biodiff";
    tag = "v${version}";
    hash = "sha256-ZLxjOV08sC5dKICvRUyL6FLMORkxwdLgNq7L45CDwa4=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-1/FNMXzEQB4LM57+SccUjJ31rYB46DO8AQYQBn6B7zg=";

  buildInputs = [ wfa2-lib ];

  # default statically links wfa2
  buildNoDefaultFeatures = true;
  buildFeatures = [ "wfa2" ];

  meta = {
    description = "Hex diff viewer using alignment algorithms from biology";
    homepage = "https://github.com/8051Enthusiast/biodiff";
    changelog = "https://github.com/8051Enthusiast/biodiff/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ newam ];
  };
}

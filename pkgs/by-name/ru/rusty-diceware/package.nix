{
  fetchFromGitLab,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-diceware";
  version = "0.5.8";

  src = fetchFromGitLab {
    owner = "yuvallanger";
    repo = "rusty-diceware";
    rev = "diceware-v${version}";
    hash = "sha256-GDWvHHl4EztTaR0jI4XL1I9qE2KSL+q9C8IvLWQF4Ys=";
  };

  cargoHash = "sha256-f+jvrokt5kuHYKKfluu4OvI7dzp9rFPlTo4KC4jKb0o=";

  doCheck = true;

  meta = {
    description = "Commandline diceware, with or without dice, written in Rustlang";
    homepage = "https://gitlab.com/yuvallanger/rusty-diceware";
    changelog = "https://gitlab.com/yuvallanger/rusty-diceware/-/blob/v${version}/CHANGELOG.md?ref_type=heads";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ cherrykitten ];
    mainProgram = "diceware";
  };
}

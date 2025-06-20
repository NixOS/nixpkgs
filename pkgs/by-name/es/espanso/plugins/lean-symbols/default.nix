{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "lean-symbols";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Insert symbols like ∑ Π α → ↦  Γ etc, the same set of symbols as the VScode lean4  extension allows you to insert, using the same shortcuts. For example '\\a\\', '\\a ', '\\aTAB',  all insert α, i.e. the greek alpha. TAB denotes a single press of the tab key.
";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}

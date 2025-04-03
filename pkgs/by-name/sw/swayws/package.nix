{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "swayws";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "swayws";
    # Specifying commit hash rather than tag because upstream has
    # rewritten a tag before:
    # https://gitlab.com/w0lff/swayws/-/issues/1#note_1342349382
    rev = "0c125d65f9fe9269f78ddaf575cd39f00f749659";
    hash = "sha256-ILS7r1gL6fXeX58CJ+gHvQ5Cst7PbK4yNw2Dh5l9IEc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AS1vEnNLDLsNaIZ6pLrsQpQy9+bSoCn5oyj8SXjJ+OE=";

  # swayws does not have any tests
  doCheck = false;

  meta = {
    description = "Sway workspace tool which allows easy moving of workspaces to and from outputs";
    mainProgram = "swayws";
    homepage = "https://gitlab.com/w0lff/swayws";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.atila ];
  };
}

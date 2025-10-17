{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
  spade,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "swim";
  version = "0.13.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "swim";
    rev = "v${version}";
    hash = "sha256-0H45kOIwFMdp+eIQJNutLUC/jEpWKsPfEZXDUOUa12g=";
  };

  cargoHash = "sha256-fF+43tZzr6lxVovMCIaDwf9JKweqiMMR+BNojIqQREY=";

  preConfigure = ''
    # de-vendor spade git submodule
    test "$version" = "${spade.version}" || {
      >&2 echo ERROR: version mismatch between spade and swim!
      false
    }
    ln -s ${spade.src} runt/spade
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [ git ];

  checkFlags = [
    # tries to clone https://gitlab.com/spade-lang/swim-templates
    "--skip=init::tests::git_init_then_swim_init_works"
    "--skip=init::tests::init_board_correctly_sets_project_name"
    "--skip=init::tests::init_board_creates_required_files"
    "--skip=plugin::test::deny_changes_to_plugins::edits_are_denied"
    "--skip=plugin::test::deny_changes_to_plugins::restores_work"
  ];

  passthru = {
    inherit (spade) updateScript;
  };

  meta = {
    description = "Build tool for spade";
    homepage = "https://gitlab.com/spade-lang/swim";
    changelog = "https://gitlab.com/spade-lang/swim/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "swim";
  };
}

{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "swayws";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = pname;
    # Specifying commit hash rather than tag because upstream has
    # rewritten a tag before:
    # https://gitlab.com/w0lff/swayws/-/issues/1#note_1342349382
    rev = "98f0d5c1896b10e890e1727654f1cf3b34a2371e";
    hash = "sha256-zeM6/x2vjZ2IL+nZz1WBf5yY4C6ovmxyvgVLD54BKVc=";
  };

  cargoHash = "sha256-VYT6wV59fraAoJgR/i6GlO8s7LUoehGtxPAggEL1eLo=";

  # swayws does not have any tests
  doCheck = false;

  meta = with lib; {
    description = "Sway workspace tool which allows easy moving of workspaces to and from outputs";
    mainProgram = "swayws";
    homepage = "https://gitlab.com/w0lff/swayws";
    license = licenses.mit;
    maintainers = [ maintainers.atila ];
  };
}

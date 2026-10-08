{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage {
  pname = "clog-cli";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "clog-tool";
    repo = "clog-cli";
    # Tag seems to be missing:
    # https://github.com/clog-tool/clog-cli/issues/128
    rev = "7066cba2bcbaea0f62ea22c320d48dac20f36a38";
    sha256 = "sha256-d1csT7iHf48kLkn6/cGhoIoEN/kiYc6vlUwHDNmbnMI=";
  };

  cargoHash = "sha256-b8/n3y6fTqP5+rZySEDEb8Z5DPHQ2jUasp5SvaJJlGo=";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = "https://github.com/clog-tool/clog-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.nthorne ];
    mainProgram = "clog";
  };
}

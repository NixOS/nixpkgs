{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  cbfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "cbfmt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = "cbfmt";
    rev = "v${version}";
    sha256 = "sha256-/ZvL1ZHXcmE1n+hHvJeSqmnI9nSHJ+zM9lLNx0VQfIE=";
  };

  cargoHash = "sha256-C1FpwC1JsKOkS59xAcwqpmZ2g7rr+HHRdADURLs+9co=";

  passthru.tests.version = testers.testVersion {
    package = cbfmt;
  };

  meta = with lib; {
    description = "Tool to format codeblocks inside markdown and org documents";
    mainProgram = "cbfmt";
    homepage = "https://github.com/lukas-reineke/cbfmt";
    license = licenses.mit;
    maintainers = [ maintainers.stehessel ];
  };
}

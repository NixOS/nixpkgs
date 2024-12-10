{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZzmInCx75IjNQBQmattc7JZwtD6zGYCQ4eTgDFz2L00=";
  };

  cargoHash = "sha256-BPLhdbC5XFsRfvObaEa4nmYWCN1FxbJzmgZK1JpBcLQ=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      unlicense
    ];
    maintainers = with maintainers; [
      figsoda
      gepbird
    ];
    mainProgram = "hck";
  };
}

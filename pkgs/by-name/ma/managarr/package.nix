{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "managarr";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${version}";
    hash = "sha256-OxGFubtMsGnR8cWDKkeAgryY095uydA3LzE5SS0dspQ=";
  };

  cargoHash = "sha256-bws4LwpJGfq0hCA2Fq51uCMvr0arbayppq1jvDrILZI=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.IncredibleLaser ];
    mainProgram = "managarr";
  };
}

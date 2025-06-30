{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cpc";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "probablykasper";
    repo = "cpc";
    tag = "v${version}";
    hash = "sha256-DjJIXV5rJxQOiMH8/0yZQBvDh+jbejzADt4WSGyhozI=";
  };

  cargoHash = "sha256-2k+aFrP/PQmlGr3gIF1queDjuo/+3KtnrOrx1+wrqEg=";

  meta = {
    mainProgram = "cpc";
    description = "Text calculator with support for units and conversion";
    homepage = "https://github.com/probablykasper/cpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      s0me1newithhand7s
    ];
  };
}

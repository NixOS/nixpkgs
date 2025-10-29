{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  version = "0.1.4";
  pname = "rconc";

  src = fetchFromGitHub {
    owner = "klemens";
    repo = "rconc";
    rev = "11def656970b9ccf35c40429b5c599a4de7b28fc";
    sha256 = "sha256-6Bff9NnG1ZEQhntzH5Iq0XEbJBKdwcb0BOn8nCkeWTY=";
  };

  cargoHash = "sha256-fkGSIPaq3SvbA9iP10sVb7gtBxo7XmHw+fz0Gt8AMXo=";

  meta = with lib; {
    description = "Simple cross-platform RCON client written in rust";
    homepage = "https://github.com/klemens/rconc";
    license = licenses.gpl3Only;
    mainProgram = "rconc";
  };
}

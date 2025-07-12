{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "procfd";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "procfd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HqetvI6IeL/3lDkaRyav71kKmkTXo0STCjdVIziWGkQ=";
  };

  cargoHash = "sha256-c0fIv1yyOwgUsdiQuKPWE4ZKLsaZRwosjswV+++bjT8=";

  meta = {
    description = "Linux lsof replacement to list open file descriptors for processes";
    homepage = "https://github.com/deshaw/procfd";
    license = lib.licenses.bsd3;
    mainProgram = "procfd";
    platforms = lib.platforms.linux;
    teams = with lib.teams; [ deshaw ];
  };
})

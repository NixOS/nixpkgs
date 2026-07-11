{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "brook";
  version = "20240606";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = "brook";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rfCqYI0T/nbK+rlPGl5orLo3qHKITesdFNtXc/ECATA=";
  };

  vendorHash = "sha256-dYiifLUOq6RKAVSXuoGlok9Jp8jHmbXN/EjQeQpoqWw=";

  meta = {
    homepage = "https://github.com/txthinking/brook";
    description = "Cross-platform Proxy/VPN software";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "brook";
  };
})

{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libversion";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = finalAttrs.version;
    hash = "sha256-USgSwAdRHEepq9ZTDHVWkPsZjljfh9sEWOZRfu0H7Go=";
  };

  nativeBuildInputs = [ cmake ];

  checkTarget = "test";
  doCheck = true;

  meta = {
    description = "Advanced version string comparison library";
    homepage = "https://github.com/repology/libversion";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.unix;
  };
})

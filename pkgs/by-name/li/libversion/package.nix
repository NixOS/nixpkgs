{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libversion";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = finalAttrs.version;
    hash = "sha256-7NyfK4mAXbIyfKzYHFkm3lmz+I0yqKmRkwm5OZXUCtw=";
  };

  nativeBuildInputs = [ cmake ];

  checkTarget = "test";
  doCheck = true;

  meta = {
    description = "Advanced version string comparison library";
    homepage = "https://github.com/repology/libversion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.unix;
  };
})

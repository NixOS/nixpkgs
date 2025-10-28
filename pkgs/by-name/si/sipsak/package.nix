{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  c-ares,
  openssl ? null,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipsak";
  version = "4.5.12.1";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    c-ares
  ];

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: transport.o:/build/source/sipsak.h:323: multiple definition of
  #     `address'; auth.o:/build/source/sipsak.h:323: first defined here
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -fcommon";

  src = fetchFromGitHub {
    owner = "sipwise";
    repo = "sipsak";
    tag = "mr${finalAttrs.version}";
    hash = "sha256-j4KF87krXvY2pcepEYRRxtadV8QxHRGICK6VrmXw5BQ=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/sipwise/sipsak";
    description = "SIP Swiss army knife";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sheenobu ];
    platforms = with lib.platforms; unix;
    mainProgram = "sipsak";
  };

})

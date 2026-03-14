{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pam,
  qrencode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "google-authenticator-libpam";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "google-authenticator-libpam";
    rev = finalAttrs.version;
    hash = "sha256-cLMX5SdKvyQr3annc/Hhhz6XgY+BypRHASKRh6xTdmo=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam ];

  preConfigure = ''
    sed -i "s|libqrencode.so.4|${qrencode.out}/lib/libqrencode.so.4|" src/google-authenticator.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/security
    cp ./.libs/pam_google_authenticator.so $out/lib/security
    cp google-authenticator $out/bin
  '';

  meta = {
    homepage = "https://github.com/google/google-authenticator-libpam";
    description = "Two-step verification, with pam module";
    mainProgram = "google-authenticator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aneeshusa ];
    platforms = lib.platforms.linux;
  };
})

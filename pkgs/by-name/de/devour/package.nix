{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "devour";
  version = "12";

  src = fetchFromGitHub {
    owner = "salman-abedin";
    repo = "devour";
    rev = finalAttrs.version;
    sha256 = "1qq5l6d0fn8azg7sj7a4m2jsmhlpswl5793clcxs1p34vy4wb2lp";
  };

  installPhase = ''
    install -Dm555 -t $out/bin devour
  '';

  buildInputs = [ libX11 ];

  meta = {
    description = "Hides your current window when launching an external program";
    longDescription = "Devour hides your current window before launching an external program and unhides it after quitting";
    homepage = "https://github.com/salman-abedin/devour";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mazurel ];
    platforms = lib.platforms.unix;
    mainProgram = "devour";
  };
})

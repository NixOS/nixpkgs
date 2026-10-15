{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "devour";
  version = "12";

  src = fetchFromGitHub {
    owner = "salman-abedin";
    repo = "devour";
    rev = finalAttrs.version;
    hash = "sha256-l4rFid9k3KA7o2ykUyjXl8KqpahEHanP+wpZB5qhBeM=";
  };

  installPhase = ''
    install -Dm555 -t $out/bin devour
  '';

  buildInputs = [ libx11 ];

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

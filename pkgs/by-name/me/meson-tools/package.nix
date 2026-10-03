{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meson-tools";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "afaerber";
    repo = "meson-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ExODp1GnjEzr4MOOdrCrnL1LlR3xKt6+FwGom5SDeq8=";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p "$out/bin"
    mv amlbootsig unamlbootsig amlinfo "$out/bin"
  '';

  meta = {
    homepage = "https://github.com/afaerber/meson-tools";
    description = "Tools for Amlogic Meson ARM platforms";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lopsided98 ];
  };
})

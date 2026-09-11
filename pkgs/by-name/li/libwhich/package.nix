{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwhich";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "vtjnash";
    repo = "libwhich";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Or436P5O7k/KGhEyDMjag+s9uxstq7k780Cl7sZYFjs=";
  };

  installPhase = ''
    install -Dm755 -t $out/bin libwhich
  '';

  meta = {
    description = "Like `which`, for dynamic libraries";
    mainProgram = "libwhich";
    homepage = "https://github.com/vtjnash/libwhich";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

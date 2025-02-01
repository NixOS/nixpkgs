{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libwhich";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "vtjnash";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JNIWdI12sL3TZqVA3GeH0KbgqFDbMsEdecea3392Goc=";
  };

  installPhase = ''
    install -Dm755 -t $out/bin libwhich
  '';

  meta = with lib; {
    description = "Like `which`, for dynamic libraries";
    mainProgram = "libwhich";
    homepage = "https://github.com/vtjnash/libwhich";
    license = licenses.mit;
    maintainers = [ ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "simpleproxy";
  version = "3.6";
  rev = "v.${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "vzaliva";
    repo = "simpleproxy";
    sha256 = "sha256-O4PncEm8LZaJDN28kwsSvCEewr+k0EAyHMu3U+JYyQQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/vzaliva/simpleproxy";
    description = "Simple TCP proxy";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.montag451 ];
    mainProgram = "simpleproxy";
  };
}

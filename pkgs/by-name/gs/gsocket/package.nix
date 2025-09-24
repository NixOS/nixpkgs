{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "gsocket";
  version = "1.4.43";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "gsocket";
    rev = "v${version}";
    hash = "sha256-7ph7YaY8rbfzvEh1ABgl3Jg15d6WBP4pywFn/nXjPKY=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl ];
  dontDisableStatic = true;

  meta = with lib; {
    description = "Connect like there is no firewall, securely";
    homepage = "https://www.gsocket.io";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.msm ];
  };
}

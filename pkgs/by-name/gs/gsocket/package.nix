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

<<<<<<< HEAD
  meta = {
    description = "Connect like there is no firewall, securely";
    homepage = "https://www.gsocket.io";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.msm ];
=======
  meta = with lib; {
    description = "Connect like there is no firewall, securely";
    homepage = "https://www.gsocket.io";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.msm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

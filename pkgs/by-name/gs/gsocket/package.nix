{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsocket";
  version = "1.4.43";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "gsocket";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7ph7YaY8rbfzvEh1ABgl3Jg15d6WBP4pywFn/nXjPKY=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl ];
  dontDisableStatic = true;

  meta = {
    description = "Connect like there is no firewall, securely";
    homepage = "https://www.gsocket.io";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.msm ];
  };
})

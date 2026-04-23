{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cconv";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "xiaoyjy";
    repo = "cconv";
    rev = "v${finalAttrs.version}";
    sha256 = "RAFl/+I+usUfeG/l17F3ltThK7G4+TekyQGwzQIgeH8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-liconv";

  meta = {
    description = "Iconv based simplified-traditional chinese conversion tool";
    mainProgram = "cconv";
    homepage = "https://github.com/xiaoyjy/cconv";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.redfish64 ];
  };
})

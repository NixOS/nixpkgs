{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiscsi";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = finalAttrs.version;
    sha256 = "sha256-idiK9JowKhGAk5F5qJ57X14Q2Y0TbIKRI02onzLPkas=";
  };

  postPatch = ''
    substituteInPlace lib/socket.c \
      --replace-fail "void iscsi_decrement_iface_rr() {" "void iscsi_decrement_iface_rr(void) {"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  env = lib.optionalAttrs (stdenv.hostPlatform.is32bit || stdenv.hostPlatform.isDarwin) {
    # iscsi-discard.c:223:57: error: format specifies type 'unsigned long' but the argument has type 'uint64_t' (aka 'unsigned long long') [-Werror,-Wformat]
    NIX_CFLAGS_COMPILE = "-Wno-error=format";
  };

  meta = {
    description = "iSCSI client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})

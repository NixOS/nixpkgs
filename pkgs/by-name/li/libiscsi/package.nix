{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiscsi";
  version = "1.20.3";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = finalAttrs.version;
    sha256 = "sha256-ARajWZ5/LIfFNCdp3HvQiyhR455+sJNzUPbBrz/pZ7E=";
  };

  postPatch = ''
    substituteInPlace lib/socket.c \
      --replace-fail "void iscsi_decrement_iface_rr() {" "void iscsi_decrement_iface_rr(void) {"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  env = lib.optionalAttrs (stdenv.hostPlatform.is32bit || stdenv.hostPlatform.isDarwin) {
    NIX_CFLAGS_COMPILE = toString [
      # iscsi-discard.c:223:57: error: format specifies type 'unsigned long' but the argument has type 'uint64_t' (aka 'unsigned long long') [-Werror,-Wformat]
      "-Wno-error=format"
      # multithreading.c:257:16: error: 'sem_init' is deprecated [-Werror,-Wdeprecated-declarations]
      "-Wno-error=deprecated-declarations"
      # scsi-lowlevel.c:1244:11: error: cast from 'uint8_t *' (aka 'unsigned char *') to 'uint16_t *' (aka 'unsigned short *') increases required alignment from 1 to 2 [-Werror,-Wcast-align]
      "-Wno-error=cast-align"
    ];
  };

  meta = {
    description = "iSCSI client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libiscsi";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = version;
    sha256 = "sha256-Hk7yi0gWhN9gW0ntbktgCgdiN7B60ujE2GjXdwsxsN0=";
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

  meta = with lib; {
    description = "iscsi client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}

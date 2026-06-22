{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfs";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    tag = "libnfs-${finalAttrs.version}";
    hash = "sha256-OFzoDCDBo+O7PtUKcyKnUJJ9TrALrkvk5Yo0zn08Q6w=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-pthread"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "NFS client library";
    homepage = "https://github.com/sahlberg/libnfs";
    license = with lib.licenses; [
      lgpl2
      bsd2
      gpl3
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})

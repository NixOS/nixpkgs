{ lib
, stdenv
, fetchFromGitea
, acl
, attr
, autoreconfHook
, libiconv
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libisofs";
  version = "1.5.6.pl01";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libisofs";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-U5We19f/X1UKYFacCRl+XRXn67W8cYOBORb2uEjanT4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    acl
    attr
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ] ++ [
    zlib
  ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://dev.lovelyhq.com/libburnia/web/wiki";
    description = "Library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    changelog = "https://dev.lovelyhq.com/libburnia/libisofs/src/tag/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ abbradar AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitea,
  acl,
  autoreconfHook,
  libiconv,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libisofs";
  version = "1.5.8.pl02";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libisofs";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-uyE+7H5zWcBgtOsoFtiLFroeqA0Kj7tg7s+1IzXNKBo=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      acl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ]
    ++ [
      zlib
    ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dev.lovelyhq.com/libburnia/web/wiki";
    description = "Library to create an ISO-9660 filesystem with extensions like RockRidge or Joliet";
    changelog = "https://dev.lovelyhq.com/libburnia/libisofs/src/tag/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.unix;
  };
})

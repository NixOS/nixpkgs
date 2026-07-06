{
  lib,
  stdenv,
  fetchFromGitHub,
  libsodium,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "equihash";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "equihash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s16MwWH/xYLl7MSayXLoQUtuTv4GsQgq+qbI14igcv8=";
  };

  strictDeps = true;

  buildInputs = [ libsodium ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Memory-hard PoW with fast verification";
    homepage = "https://github.com/stef/equihash/";
    license = lib.licenses.cc0;
    teams = [ lib.teams.ngi ];
    # ld -z not available on darwin
    platforms = lib.platforms.linux;
  };
})

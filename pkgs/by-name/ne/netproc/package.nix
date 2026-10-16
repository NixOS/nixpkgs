{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netproc";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "berghetti";
    repo = "netproc";
    rev = finalAttrs.version;
    hash = "sha256-EqCyh0WNz7B2B1SFgFQT2MFk8+OVPsy5n3EFt64HJ+E=";
  };

  buildInputs = [ ncurses ];

  installFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to monitor network traffic based on processes";
    homepage = "https://github.com/berghetti/netproc";
    license = lib.licenses.gpl3;
    mainProgram = "netproc";
    maintainers = [ lib.maintainers.azuwis ];
    platforms = lib.platforms.linux;
  };
})

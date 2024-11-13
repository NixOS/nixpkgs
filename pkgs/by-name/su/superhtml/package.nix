{
  lib,
  callPackage,
  fetchFromGitHub,
  stdenv,
  zig,
}:
stdenv.mkDerivation rec {
  pname = "superhtml";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    rev = "refs/tags/v${version}";
    hash = "sha256-ubFFFHlYTYmivVI5hd/Mj+jFIBuPQ/IycNv3BLxkeuc=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = with lib; {
    description = "HTML Language Server and Templating Language Library";
    homepage = "https://github.com/kristoff-it/superhtml";
    license = licenses.mit;
    mainProgram = "superhtml";
    maintainers = with maintainers; [ petertriho ];
    platforms = platforms.unix;
  };
}

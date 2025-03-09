{
  lib,
  callPackage,
  fetchFromGitHub,
  stdenv,
  zig,
}:
stdenv.mkDerivation rec {
  pname = "superhtml";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    rev = "refs/tags/v${version}";
    hash = "sha256-rO7HS07nSqwOq6345q/SOL2imoD0cKV16QJcVVr6mHw=";
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

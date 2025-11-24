{
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "om4";
  version = "6.7";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "m4";
    tag = "om4-${version}";
    hash = "sha256-/b+Fcz6lg2hW541TzBhB9M86wUS7BT6pHzqXxTs0BxI=";
  };

  patches = [
    # parser.y:51:25: error: implicit declaration of function 'exit' []
    ./include-exit.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    bison
    flex
  ];

  configureFlags = [ "--enable-m4" ];

  meta = {
    description = "Portable OpenBSD m4 macro processor";
    homepage = "https://github.com/ibara/m4";
    license = with lib.licenses; [
      bsd2
      bsd3
      isc
      publicDomain
    ];
    mainProgram = "m4";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}

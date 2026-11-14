{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bashInteractive,
  xdg-utils,
  file,
  coreutils,
  w3m,
  xdotool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fff";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "fff";
    rev = finalAttrs.version;
    hash = "sha256-D+rMibs/6GAWJBuwyO7lUdn/ZmnZBdcBjRZeQw1v1ZM=";
  };

  pathAdd = lib.makeSearchPath "bin" [
    xdg-utils
    file
    coreutils
    w3m
    xdotool
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashInteractive ];
  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram "$out/bin/fff" --prefix PATH : $pathAdd
  '';

  meta = {
    description = "Fucking Fast File-Manager";
    mainProgram = "fff";
    homepage = "https://github.com/dylanaraps/fff";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

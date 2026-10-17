{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "reattach-to-user-namespace";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "ChrisJohnsen";
    repo = "tmux-MacOSX-pasteboard";
    rev = "v${version}";
    hash = "sha256-6TwF3gyhMjoWQ02ZYPhseXtlRrtTyGeIcaUziAqs8eE=";
  };

  buildFlags =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      [ "ARCHES=x86_64" ]
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      [ "ARCHES=arm64" ]
    else
      throw "reattach-to-user-namespace isn't being built for ${stdenv.hostPlatform.system} yet.";

  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';

  meta = {
    description = "Wrapper that provides access to the Mac OS X pasteboard service";
    homepage = "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}

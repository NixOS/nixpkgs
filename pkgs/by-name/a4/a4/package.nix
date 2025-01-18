{
  lib,
  stdenv,
  fetchFromGitHub,
  libtickit,
  libvterm-neovim,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "a4";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rpmohn";
    repo = "a4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AX5psz9+bLdFFeDR55TIrAWDAkhDygw6289OgIfOJTg=";
  };

  buildInputs = [
    libtickit
    libvterm-neovim
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Dynamic terminal window manager";
    homepage = "https://www.a4term.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    platforms = platforms.linux;
    mainProgram = "a4";
  };
})

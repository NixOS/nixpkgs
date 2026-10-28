{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  xorgproto,
  libice,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iceauth";
  version = "1.0.11";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "iceauth";
    tag = "iceauth-${finalAttrs.version}";
    hash = "sha256-HuC5q5kFek2v+Rzp+TgSRnl6Dr4eKtSl7SuSwfFvOdM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
  ];

  buildInputs = [
    xorgproto
    libice
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=iceauth-(.*)" ]; };

  meta = {
    description = "libICE authority file utility";
    longDescription = ''
      The iceauth program is used to edit and display the authorization information used in
      connecting with ICE (the X11 Inter-Client Exchange protocol). It operates very much like the
      xauth program for X11 connection authentication records.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/iceauth";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "iceauth";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

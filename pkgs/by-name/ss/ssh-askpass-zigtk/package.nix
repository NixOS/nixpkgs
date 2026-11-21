{
  lib,
  stdenv,
  fetchFromForgejo,
  zig,
  pkg-config,
  gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssh-askpass-zigtk";
  version = "0.1.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "tty.fail";
    owner = "mrus";
    repo = "ssh-askpass-zigtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2NoM3TLSTJ4Gf+C+qGvq/Y2q9Va+wmmcM9FE9xeunWE=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
  ];

  propagatedBuildInputs = [ gtk4 ];

  doCheck = true;

  meta = {
    description = "ssh-askpass using GTK4 without X11 dependencies and written in Zig";
    homepage = "https://tty.fail/mrus/ssh-askpass-zigtk";
    license = lib.licenses.segv;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
    mainProgram = "ssh-askpass-zigtk";
  };
})

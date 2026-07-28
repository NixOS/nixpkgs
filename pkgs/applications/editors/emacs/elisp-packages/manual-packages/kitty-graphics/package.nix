{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nix-update-script,
}:

melpaBuild {
  pname = "kitty-graphics";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cashmeredev";
    repo = "kitty-graphics.el";
    rev = "v1.0.0";
    hash = "sha256-wctqnbM7vdQndXl6uArLdfMHYdU6tdN7MWp2Rxdz668=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display images in terminal Emacs (emacs -nw) via the Kitty graphics protocol or Sixel";
    homepage = "https://github.com/cashmeredev/kitty-graphics.el";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.shunueda ];
  };
}

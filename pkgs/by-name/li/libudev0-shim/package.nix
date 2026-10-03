{
  lib,
  stdenv,
  fetchFromGitHub,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libudev0-shim";
  version = "1";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "libudev0-shim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HxQ+RWuzlbL+wkvJte/SqIYUzidC0jS0tZiFm03FwJA=";
  };

  buildInputs = [ udev ];

  installPhase = ''
    name="$(echo libudev.so.*)"
    install -Dm755 "$name" "$out/lib/$name"
    ln -s "$name" "$out/lib/libudev.so.0"
  '';

  meta = {
    description = "Shim to preserve libudev.so.0 compatibility";
    homepage = "https://github.com/archlinux/libudev0-shim";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
})

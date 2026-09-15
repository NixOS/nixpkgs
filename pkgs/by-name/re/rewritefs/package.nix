{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  pcre2,
}:

stdenv.mkDerivation {
  pname = "rewritefs";
  version = "0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "rewritefs";
    rev = "7a4f971ed4c3e8c838c01c924340a0eed22d3b0f";
    sha256 = "sha256-Vv9W7zQIILwxfFZmdZcUnJlMYGeHFt9WUXcliACnNoE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse3
    pcre2
  ];

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace Makefile --replace 6755 0755
  '';

  preConfigure = "substituteInPlace Makefile --replace /usr/local $out";

  meta = {
    description = "FUSE filesystem intended to be used like Apache mod_rewrite";
    homepage = "https://github.com/sloonz/rewritefs";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acr";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "acr";
    rev = finalAttrs.version;
    hash = "sha256-GgF2sen7RcnuXrtLzkeGllMvY65LffR+jPPqUhbsOGk=";
  };

  preConfigure = ''
    chmod +x ./autogen.sh && ./autogen.sh
  '';

  meta = {
    homepage = "https://github.com/radareorg/acr/";
    description = "Pure shell autoconf replacement";
    longDescription = ''
      ACR tries to replace autoconf functionality generating a full-compatible
      'configure' script (runtime flags). But using shell-script instead of
      m4. This means that ACR is faster, smaller and easy to use.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})

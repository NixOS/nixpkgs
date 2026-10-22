{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdf2sfd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = "bdf2sfd";
    tag = finalAttrs.version;
    sha256 = "sha256-Kif+SG/Cq+HYNMwil2256Bst0Z7qzaImycSWdMhDk4E=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "bdf2sfd";
  };
})

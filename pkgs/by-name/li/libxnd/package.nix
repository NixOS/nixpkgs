{
  lib,
  stdenv,
  fetchFromGitHub,
  libndtypes,
}:

stdenv.mkDerivation {
  pname = "libxnd";
  version = "0.2.0-unstable-2023-11-17";

  src = fetchFromGitHub {
    owner = "xnd-project";
    repo = "libxnd";
    rev = "e1a06d9f6175f4f4e1da369b7e907ad6b2952c00";
    hash = "sha256-RWt2Nx0tfMghQES2SM+0jbAU7IunuuTORhBe2tvqVTY=";
  };

  buildInputs = [ libndtypes ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [
    # Override linker with cc (symlink to either gcc or clang)
    # Library expects to use cc for linking
    "LD=${stdenv.cc.targetPrefix}cc"
    # needed for tests
    "--with-includes=${libndtypes}/include"
    "--with-libs=${libndtypes}/lib"
  ];

  # other packages which depend on libxnd seem to expect overflow.h, but
  # it doesn't seem to be included in the installed headers. for now this
  # works, but the generic name of the header could produce problems
  # with collisions down the line.
  postInstall = ''
    cp libxnd/overflow.h $out/include/overflow.h
  '';

  doCheck = true;

  meta = {
    description = "C library for managing typed memory blocks and Python container module";
    homepage = "https://xnd.io/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}

{
  stdenv,
  gnat13,
  gnat13Packages,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "florist";
  version = "26.1";

  src = fetchFromGitHub {
    owner = "adacore";
    repo = "florist";
    rev = "refs/heads/${finalAttrs.version}";
    hash = "sha256-83bfO7RTVs3b7nEzjxnr2eRXggoMjTLIa9agwYKgP9g=";
  };

  configureFlags = [ "--enable-shared" ];

  nativeBuildInputs = [
    gnat13
    gnat13Packages.gprbuild
  ];

  meta = {
    description = "Posix Ada Bindings";
    homepage = "https://github.com/adacore/florist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lutzberger ];
    platforms = lib.platforms.linux;
  };
})

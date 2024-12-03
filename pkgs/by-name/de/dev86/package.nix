{ lib
, stdenv
, fetchFromGitea
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
  version = "0-unstable-2024-03-28";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "dev86";
    rev = "a6a438062e8e36a7407d44c41a3958a4451e598d";
    hash = "sha256-8aris/WLHMEOs2Eg8XfEUTaYIpmUk1NTEaRxm7xLreU=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Parallel builds are not supported due to build process structure: tools are
  # built sequentially in submakefiles and are reusing the same targets as
  # dependencies. Building dependencies in parallel from different submakes is
  # not synchronized and fails:
  #     make[3]: Entering directory '/build/dev86-0.16.21/libc'
  #     Unable to execute as86.
  enableParallelBuilding = false;

  meta = {
    homepage = "https://github.com/jbruchon/dev86";
    description =
      "C compiler, assembler and linker environment for the production of 8086 executables";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres sigmasquadron ];
    platforms = lib.platforms.linux;
  };
})

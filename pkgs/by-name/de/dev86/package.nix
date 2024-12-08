{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
  version = "unstable-2022-07-19";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo = "dev86";
    rev = "f5cd3e5c17a0d3cd8298bac8e30bed6e59c4e57a";
    hash = "sha256-CWeboFkJkpKHZ/wkuvMj5a+5qB2uzAtoYy8OdyYErMg=";
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

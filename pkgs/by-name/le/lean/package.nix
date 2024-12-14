{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gmp,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.51.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean";
    # lean's version string contains the commit sha1 it was built
    # from. this is then used to check whether an olean file should be
    # rebuilt. don't use a tag as rev because this will get replaced into
    # src/githash.h.in in preConfigure.
    rev = "9fc1dee97a72a3e34d658aefb4b8a95ecd3d477c";
    hash = "sha256-Vcsph4dTNLafeaTtVwJS8tWoWCgcP6pxF0ssZDE/YfM=";
  };

  patches = [
    # Fix gcc-13 build failure
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/leanprover-community/lean/commit/21d264a66d53b0a910178ae7d9529cb5886a39b6.patch";
      hash = "sha256-hBm2QNFS1jdoR6LUQHLReKxMKv7kbkrkrTGJ43YnvfA=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];

  cmakeDir = "../src";

  # Running the tests is required to build the *.olean files for the core
  # library.
  doCheck = true;

  preConfigure =
    assert builtins.stringLength src.rev == 40;
    ''
      substituteInPlace src/githash.h.in \
        --subst-var-by GIT_SHA1 "${src.rev}"
      substituteInPlace library/init/version.lean.in \
        --subst-var-by GIT_SHA1 "${src.rev}"
    '';

  postPatch = "patchShebangs .";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace $out/bin/leanpkg \
      --replace "greadlink" "${coreutils}/bin/readlink"
  '';

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      gebner
    ];
  };
}

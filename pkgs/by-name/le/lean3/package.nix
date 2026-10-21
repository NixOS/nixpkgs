{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gmp,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.51.1c"; # last version

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "lean";
    # lean's version string contains the commit sha1 it was built
    # from. this is then used to check whether an olean file should be
    # rebuilt. don't use a tag as rev because this will get replaced into
    # src/githash.h.in in preConfigure.
    rev = "f91b574c40ad862c5134d48995ad083fe48e4cd4";
    hash = "sha256-Z2DohYFZF58KVzXlmIoXl6y9jsiRuZaCLOesjpwosz0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];

  cmakeDir = "../src";

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

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

  postPatch = ''
    patchShebangs .

    sed -e '1i #include <cstdint>' -i src/util/hash.{cpp,h}
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=template-body";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace $out/bin/leanpkg \
      --replace "greadlink" "${coreutils}/bin/readlink"
  '';

  meta = {
    broken = true;
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
    ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgreen";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = finalAttrs.version;
    sha256 = "sha256-W4MdB3acZcxavjRupJa4eXAv9g4QgYXFAQWOLoHrQZ8=";
  };

  postPatch = ''
    for F in tools/discoverer_acceptance_tests.c tools/discoverer.c; do
      substituteInPlace "$F" --replace "/usr/bin/nm" "nm"
    done
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/cgreen-devs/cgreen";
    description = "Modern Unit Test and Mocking Framework for C and C++";
    mainProgram = "cgreen-runner";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

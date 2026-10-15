{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crex";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "octobanana";
    repo = "crex";
    rev = finalAttrs.version;
    hash = "sha256-I99IGonqa2WCbSoEtyaq3QaIQ8B+YP2YQuSTRCjf2SA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/usr/local/bin" "bin"
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Explore, test, and check regular expressions in the terminal";
    homepage = "https://octobanana.com/software/crex";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "crex";
  };
})

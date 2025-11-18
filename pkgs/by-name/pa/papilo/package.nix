{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  onetbb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papilo";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VHOwr3uIhurab1zI9FeecBXZIp1ee2pk8fhVak6H0+A=";
  };

  # skip SEGFAULT tests
  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace test/CMakeLists.txt \
        --replace-fail '"matrix-buffer"' "" \
        --replace-fail '"vector-comparisons"' "" \
        --replace-fail '"matrix-comparisons"' "" \
        --replace-fail '"presolve-activity-is-updated-correctly-huge-values"' "" \
        --replace-fail '"problem-comparisons"' "" \
        --replace-fail "Boost_IOSTREAMS_FOUND" "FALSE"
    ''
    + (lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      substituteInPlace test/CMakeLists.txt \
        --replace-fail '"happy-path-replace-variable"' ""
    '');

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    onetbb
  ];

  propagatedBuildInputs = [ onetbb ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://scipopt.org/";
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = with lib.licenses; [ lgpl3Plus ];
    mainProgram = "papilo";
    maintainers = with lib.maintainers; [ david-r-cox ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "ggmorse";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "ggmorse";
    rev = "8fb433d6cd6a71940f51b5724663ec0c75bf0b62";
    hash = "sha256-6GhyPhzNNAx1DSomfIfejbnLTckKa7/+VUZhSaGvGtI=";
  };

  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.0)" \
                     "cmake_minimum_required (VERSION 3.5)"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "GGMORSE_BUILD_EXAMPLES" false)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Morse code decoding library";
    homepage = "https://github.com/ggerganov/ggmorse";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nekowinston ];
    platforms = lib.platforms.unix;
  };
}

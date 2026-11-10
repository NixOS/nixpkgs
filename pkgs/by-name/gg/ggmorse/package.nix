{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "ggmorse";
  version = "0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "ggmorse";
    rev = "7b4822a8cfdbb1addfe497f3ae8186f142a4ee79";
    hash = "sha256-cxWGcMvqUtdgtQUPnqBMaSmACXPg7lx1AgW2cJbUGQQ=";
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

{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "inmarsatc";
  version = "0-unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "cropinghigh";
    repo = "inmarsatc";
    rev = "cda1242e79981d71cd8608e971c8dbc691942b10";
    hash = "sha256-UCmdHR9bSr1x4G0OP7n+o6pdS1thTl9hzH7YMykSiGw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "C++ library with functions to receive Inmarsat-C signals";
    homepage = "https://github.com/cropinghigh/inmarsatc";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nekowinston ];
    platforms = lib.platforms.linux;
  };
}

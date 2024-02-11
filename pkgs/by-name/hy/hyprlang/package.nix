{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lm1Bq2AduKFYHdl/q0OLYOdYBTHnKyHGewwQa68q/Wc=";
  };

  nativeBuildInputs = [cmake];

  outputs = ["out" "dev"];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "The official implementation library for the hypr config language";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})

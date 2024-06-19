{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8KvVqtApNt4FWTdn1TqVvw00rpqyG9UuUPA2ilPVD1U=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers =  with lib.maintainers; [
      donovanglover
      johnrtitor
    ];
  };
})

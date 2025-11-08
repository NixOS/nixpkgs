{
  ioquake3,
  fetchFromGitHub,
  pan-bindings,
  libsodium,
  lib,
}:
ioquake3.overrideAttrs (old: {
  pname = "ioq3-scion";
  version = "unstable-2024-12-14";
  buildInputs = old.buildInputs ++ [
    pan-bindings
    libsodium
  ];
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "ioq3-scion";
    rev = "a21c257b9ad1d897f6c31883511c3f422317aa0a";
    hash = "sha256-CBy3Av/mkFojXr0tAXPRWKwLeQJPebazXQ4wzKEmx0I=";
  };
  meta = {
    description = "ioquake3 with support for path aware networking";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})

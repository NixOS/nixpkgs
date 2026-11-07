{
  lib,
  stdenv,
  fetchFromGitLab,
  arpa2cm,
  arpa2common,
  cmake,
  libkrb5,
  pkg-config,
  python3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "Pavlov";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "Pavlov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xBvQCusKzl1+SsRO/L6l/x5jZYhcjjSkW3a/4B+ZVMY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    arpa2common
    cmake
    libkrb5
    pkg-config
    python3
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    libkrb5
  ];

  prePatch = ''
    patchShebangs test
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stimulus-response library and test program, based on a simple regular expression language";
    homepage = "https://gitlab.com/arpa2/Pavlov";
    # NO license yet? license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})

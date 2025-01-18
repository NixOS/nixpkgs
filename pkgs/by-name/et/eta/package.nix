{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eta";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "aioobe";
    repo = "eta";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UQ8ZoxFAy5dKtXTLwPolPMd7YJeEjsK639RkGCMY6rU=";
  };

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    description = "Tool for monitoring progress and ETA of an arbitrary process";
    homepage = "https://github.com/aioobe/eta";
    license = licenses.gpl3Only;
    mainProgram = "eta";
    maintainers = with maintainers; [ heisfer ];
    platforms = platforms.linux;
  };
})

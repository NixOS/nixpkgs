{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "progress";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-riewkageSZIlwDNMjYep9Pb2q1GJ+WMXazokJGbb4bE=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "progress";
  };
})

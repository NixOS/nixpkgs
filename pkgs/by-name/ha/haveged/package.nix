{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "haveged";
  version = "1.9.19";

  src = fetchFromGitHub {
    owner = "jirka-h";
    repo = "haveged";
    rev = "v${version}";
    hash = "sha256-tq4OXLlyC6exJEZ80H1gQQRBgYGbu+3kGz99RxsyauI=";
  };

  strictDeps = true;

  postPatch = ''
    patchShebangs ent # test shebang
  '';

  installFlags = [
    "sbindir=$(out)/bin" # no reason for us to have a $out/sbin, its just a symlink to $out/bin
  ];

  doCheck = true;

  meta = {
    description = "Simple entropy daemon";
    mainProgram = "haveged";
    longDescription = ''
      The haveged project is an attempt to provide an easy-to-use, unpredictable
      random number generator based upon an adaptation of the HAVEGE algorithm.
      Haveged was created to remedy low-entropy conditions in the Linux random device
      that can occur under some workloads, especially on headless servers. Current development
      of haveged is directed towards improving overall reliability and adaptability while minimizing
      the barriers to using haveged for other tasks.
    '';
    homepage = "https://github.com/jirka-h/haveged";
    changelog = "https://raw.githubusercontent.com/jirka-h/haveged/v${version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin; # fails to build since v1.9.15
  };
}

{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "srm";
  version = "1.2.15-unstable-2017-12-18";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/srm/srm/trunk/";
    rev = "268";
    sha256 = "sha256-bY8p6IS5zeByoe/uTmvBAaBN4Wu7J19dVSpbtqx4OeQ=";
  };

  patches = [ ./fix-output-in-verbose-mode.patch ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Delete files securely";
    longDescription = ''
      srm (secure rm) is a command-line compatible rm(1) which
      overwrites file contents before unlinking. The goal is to
      provide drop in security for users who wish to prevent recovery
      of deleted information, even if the machine is compromised.
    '';
    homepage = "https://srm.sourceforge.net";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "limitcpu";
  version = "3.2";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/cpulimit-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Wf/rGjUXr+RZmHFL6EGSYKQ2MvfOwI8LAmwezN/1fPw=";
  };

  buildFlags = with stdenv; [
    (
      if isDarwin then
        "osx"
      else if isFreeBSD then
        "freebsd"
      else
        "cpulimit"
    )
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://limitcpu.sourceforge.net/";
    description = "Tool to throttle the CPU usage of programs";
    platforms = with lib.platforms; linux ++ freebsd;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rycee ];
    mainProgram = "cpulimit";
  };
})

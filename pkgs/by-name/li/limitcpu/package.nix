{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "limitcpu";
  version = "3.1";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/cpulimit-${version}.tar.gz";
    sha256 = "sha256-lGmU7GDznwMJW4m9dOZguJwUyCq6dUVmk5jjArx7I0w=";
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
}

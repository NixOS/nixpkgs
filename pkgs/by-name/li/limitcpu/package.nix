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

  meta = with lib; {
    homepage = "https://limitcpu.sourceforge.net/";
    description = "Tool to throttle the CPU usage of programs";
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.rycee ];
    mainProgram = "cpulimit";
  };
}

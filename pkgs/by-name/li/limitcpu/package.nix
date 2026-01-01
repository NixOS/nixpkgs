{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "limitcpu";
<<<<<<< HEAD
  version = "3.2";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/cpulimit-${version}.tar.gz";
    sha256 = "sha256-Wf/rGjUXr+RZmHFL6EGSYKQ2MvfOwI8LAmwezN/1fPw=";
=======
  version = "3.1";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/cpulimit-${version}.tar.gz";
    sha256 = "sha256-lGmU7GDznwMJW4m9dOZguJwUyCq6dUVmk5jjArx7I0w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://limitcpu.sourceforge.net/";
    description = "Tool to throttle the CPU usage of programs";
    platforms = with lib.platforms; linux ++ freebsd;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rycee ];
=======
  meta = with lib; {
    homepage = "https://limitcpu.sourceforge.net/";
    description = "Tool to throttle the CPU usage of programs";
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.rycee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cpulimit";
  };
}

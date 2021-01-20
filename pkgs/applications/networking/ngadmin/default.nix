{ stdenv, lib, fetchgit, autoreconfHook, readline }:

stdenv.mkDerivation {
  pname = "ngadmin";
  version = "unstable-2017-11-17";

  src = fetchgit {
    url = "https://git.netgeek.ovh/c/ngadmin.git";
    rev = "95240c567b5c40129d733cbd76911ba7574e4998";
    sha256 = "052ss82fs8cxk3dqdwlh3r8q9gsm36in2lxdgwj9sljdgwg75c34";
  };

  nativeBuildInputs = [ autoreconfHook readline ];
  enableParallelBuild = true;

  meta = with lib; {
    description = "Netgear switch (NSDP) administration tool";
    homepage = "https://www.netgeek.ovh/wiki/projets:ngadmin";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
  };
}

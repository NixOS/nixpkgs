{ fetchurl, lib, stdenv, bash, perl }:

stdenv.mkDerivation rec {
  pname = "rush";
  version = "2.4";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Jm80iJq2pwO/CJCItSN8gUo5ThxRQsG0Z5TYVtWSEts=";
  };

  strictDeps = true;
  buildInputs = [ bash ];

  postInstall = ''
    substituteInPlace $out/bin/rush-po \
      --replace "exec perl" "exec ${lib.getExe perl}"
  '';

  doCheck = true;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Restricted User Shell";

    longDescription = ''
         GNU Rush is a Restricted User Shell, designed for sites
         providing limited remote access to their resources, such as
         svn or git repositories, scp, or the like.  Using a
         sophisticated configuration file, Rush gives you complete
         control over the command lines that users execute, as well as
         over the usage of system resources, such as virtual memory,
         CPU time, etc.

         In particular, it allows remote programs to be run in a chrooted
         environment, which is important with such programs as
         sftp-server or scp, that lack this ability.
      '';

    homepage = "https://www.gnu.org/software/rush/";
    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
  };

  passthru = {
    shellPath = "/bin/rush";
  };
}

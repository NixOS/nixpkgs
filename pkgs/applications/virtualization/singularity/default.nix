{ stdenv
, fetchFromGitHub
, autoreconfHook
, gnutar
, which
, gnugrep
, coreutils
, python
, e2fsprogs
, makeWrapper
, squashfsTools
, gzip
, gnused
, curl
, utillinux
, libarchive
, file
 }:

stdenv.mkDerivation rec {
  name = "singularity-${version}";
  version = "2.6.0";

  enableParallelBuilding = true;

  patches = [ ./env.patch ];

  preConfigure = ''
    sed -i 's/-static//g' src/Makefile.am
    patchShebangs .
  '';

  configureFlags = [ "--localstatedir=/var" ];
  installFlags = "CONTAINER_MOUNTDIR=dummy CONTAINER_FINALDIR=dummy CONTAINER_OVERLAY=dummy SESSIONDIR=dummy";

  fixupPhase = ''
    patchShebangs $out
    for f in $out/libexec/singularity/helpers/help.sh $out/libexec/singularity/cli/*.exec $out/libexec/singularity/bootstrap-scripts/*.sh ; do
      chmod a+x $f
      sed -i 's| /sbin/| |g' $f
      sed -i 's| /bin/bash| ${stdenv.shell}|g' $f
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath buildInputs}
    done
  '';

  src = fetchFromGitHub {
    owner = "singularityware";
    repo = "singularity";
    rev = version;
    sha256 = "0bi7acgppbkfbra8r29s1ldq02lazdww0z2h1rfvv8spr8dzzi94";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ coreutils gnugrep python e2fsprogs which gnutar squashfsTools gzip gnused curl utillinux libarchive file ];

  meta = with stdenv.lib; {
    homepage = http://singularity.lbl.gov/;
    description = "Designed around the notion of extreme mobility of compute and reproducible science, Singularity enables users to have full control of their operating system environment";
    license = "BSD license with 2 modifications";
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}

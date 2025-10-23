{
  lib,
  stdenv,
  fetchurl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "mylvmbackup";
  version = "0.16";

  src = fetchurl {
    url = "https://www.lenzg.net/mylvmbackup/${pname}-${version}.tar.gz";
    sha256 = "sha256-vb7M3EPIrxIz6jUwm241fzaEz2czqdCObrFgSOSgJRU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs mylvmbackup
    substituteInPlace Makefile \
      --replace "prefix = /usr/local" "prefix = ${placeholder "out"}" \
      --replace "sysconfdir = /etc" "sysconfdir = ${placeholder "out"}/etc" \
      --replace "/usr/bin/install" "install"
  '';

  postInstall = ''
    wrapProgram "$out/bin/mylvmbackup" \
      --prefix PERL5LIB : "${
        perlPackages.makePerlPath (
          with perlPackages;
          [
            ConfigIniFiles
            DBDmysql
            DBI
            TimeDate
            FileCopyRecursive
          ]
        )
      }"
  '';

  meta = {
    homepage = "https://www.lenzg.net/mylvmbackup/";
    description = "Tool for quickly creating full physical backups of a MySQL server's data files";
    mainProgram = "mylvmbackup";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = with lib.platforms; linux;
  };
}

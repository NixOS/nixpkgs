{ fetchurl, stdenv, pythonPackages, libmms }:

let version = "3.2";
in
  pythonPackages.buildPythonApplication {
    name = "mimms-${version}";
    src = fetchurl {
      url = "http://download.savannah.gnu.org/releases/mimms/mimms-${version}.tar.bz2";
      sha256 = "0zmcd670mpq85cs3nvdq3i805ba0d1alqahfy1m9cpf7kxrivfml";
    };

    postInstall = ''
      wrapProgram $out/bin/mimms \
        --prefix LD_LIBRARY_PATH : ${libmms}/lib
    '';

    meta = {
      homepage = https://savannah.nongnu.org/projects/mimms/;
      license = stdenv.lib.licenses.gpl3;
      description = "An mms (e.g. mms://) stream downloader";

      longDescription = ''
        mimms is a program designed to allow you to download streams
        using the MMS protocol and save them to your computer, as
        opposed to watching them live. Similar functionality is
        available in full media player suites such as Xine, MPlayer,
        and VLC, but mimms is quick and easy to use and, for the time
        being, remains a useful program.
      '';
    };
  }

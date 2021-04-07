{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonPackage rec {
  pname = "qnotero";

  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ealbiter";
    repo = pname;
    rev = "v${version}";
    sha256 = "16ckcjxa3dgmz1y8gd57q2h84akra3j4bgl4fwv4m05bam3ml1xs";
  };

  propagatedBuildInputs = [ python3Packages.pyqt5 wrapQtAppsHook ];

  patchPhase = ''
      substituteInPlace ./setup.py \
        --replace "/usr/share" "usr/share"

      substituteInPlace ./libqnotero/_themes/light.py \
         --replace "/usr/share" "$out/usr/share"
  '';

  preFixup = ''
    wrapQtApp "$out"/bin/qnotero
  '';

  # no tests executed
  doCheck = false;

  meta = {
    description = "Quick access to Zotero references";
    homepage = "http://www.cogsci.nl/software/qnotero";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.nico202 ];
  };
}

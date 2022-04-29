{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonPackage rec {
  pname = "qnotero";

  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "ealbiter";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y2xph4ha07slni039s034cn1wsk3q2d86hihy97h4ch47ignv20";
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

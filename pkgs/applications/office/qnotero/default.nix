{ stdenv, fetchFromGitHub, python3Packages
}:

python3Packages.buildPythonPackage rec {
  name = "qnotero-${version}";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "smathot";
    repo = "qnotero";
    rev = "release/${version}";
    name = "qnotero-${version}-src";
    sha256 = "1d5a9k1llzn9q1qv1bfwc7gfflabh4riplz9jj0hf04b279y1bj0";
  };

  propagatedBuildInputs = [ python3Packages.pyqt4 ];

  patchPhase = ''
      substituteInPlace ./setup.py \
        --replace "/usr/share" "usr/share"

      substituteInPlace ./libqnotero/_themes/default.py \
         --replace "/usr/share" "$out/usr/share"
  '';

  meta = {
    description = "Quick access to Zotero references";
    homepage = http://www.cogsci.nl/software/qnotero;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}

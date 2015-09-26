{ fetchFromGitHub, stdenv, pythonPackages, gtk3, gobjectIntrospection, libnotify
, gst_all_1, wrapGAppsHook }:

pythonPackages.buildPythonPackage rec {
  name = "pithos-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "pithos";
    repo  = "pithos";
    rev = version;
    sha256 = "0373z7g1wd3g1xl8m4ipx5n2ka67a2wcn387nyk8yvgdikm14jm3";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "/usr/share" "$out/share"
  '';

  buildInputs = [ wrapGAppsHook ];

  propagatedBuildInputs =
    [ gtk3 gobjectIntrospection libnotify ] ++
    (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ]) ++
    (with pythonPackages; [ pygobject3 pylast ]);

  meta = with stdenv.lib; {
    description = "Pandora Internet Radio player for GNOME";
    homepage = https://pithos.github.io/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz jgeerds ];
  };
}

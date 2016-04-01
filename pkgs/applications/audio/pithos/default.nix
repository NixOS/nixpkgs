{ fetchFromGitHub, stdenv, pythonPackages, gtk3, gobjectIntrospection, libnotify
, gst_all_1, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  pname = "pithos";
  version = "1.1.2";
  name = "${pname}-${version}";

  namePrefix = "";

  src = fetchFromGitHub {
    owner = pname;
    repo  = pname;
    rev = version;
    sha256 = "0zk9clfawsnwmgjbk7y5d526ksxd1pkh09ln6sb06v4ygaiifcxp";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "/usr/share" "$out/share"
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp -v data/pithos.desktop $out/share/applications
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

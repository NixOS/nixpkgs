{
  stdenv,
  lib,
  fetchFromGitLab,
  gobject-introspection,
  intltool,
  python3,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "onioncircuits";
  version = "0.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.tails.boum.org";
    owner = "tails";
    repo = "onioncircuits";
    rev = version;
    sha256 = "sha256-5VGOuvngZvUFQ+bubdt4YV3/IflOhBB1i+oEQaV4kr0=";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    wrapGAppsHook3
    python3.pkgs.distutils-extra
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    stem
  ];

  postInstall = ''
    mkdir -p $out/etc/apparmor.d

    cp apparmor/usr.bin.onioncircuits $out/etc/apparmor.d
  '';

  meta = with lib; {
    homepage = "https://tails.boum.org";
    description = "GTK application to display Tor circuits and streams";
    mainProgram = "onioncircuits";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wattmto ];
  };
}

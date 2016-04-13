{ stdenv, python27Packages, fetchgit }:
let
  py = python27Packages;
  python = py.python;
in
py.buildPythonApplication rec {
  name = "loxodo-0.20150124";

  src = fetchgit {
    url = "https://github.com/sommer/loxodo.git";
    rev = "6c56efb4511fd6f645ad0f8eb3deafc8071c5795";
    sha256 = "02whmv4am8cz401rplplqzbipkyf0wd69z43sd3yw05rh7f3xbs2";
  };

  propagatedBuildInputs = with py; [ wxPython python.modules.readline ];

  postInstall = ''
    mv $out/bin/loxodo.py $out/bin/loxodo
    mkdir -p $out/share/applications
    cat > $out/share/applications/loxodo.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Exec=$out/bin/loxodo
    Icon=$out/lib/${python.libPrefix}/site-packages/resources/loxodo-icon.png
    Name=Loxodo
    GenericName=Password Vault
    Categories=Application;Other;
    EOF
  '';

  meta = with stdenv.lib; {
    description = "A Password Safe V3 compatible password vault";
    homepage = http://www.christoph-sommer.de/loxodo/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

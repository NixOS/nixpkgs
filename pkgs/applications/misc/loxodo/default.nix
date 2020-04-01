{ stdenv, python27Packages, fetchgit }:
let
  py = python27Packages;
  python = py.python;
in
py.buildPythonApplication {
  name = "loxodo-0.20150124";

  src = fetchgit {
    url = "https://github.com/sommer/loxodo.git";
    rev = "6c56efb4511fd6f645ad0f8eb3deafc8071c5795";
    sha256 = "1cg0dfcv57ps54f1a0ksib7hgkrbdi9q699w302xyyfyvjcb5dd2";
  };

  propagatedBuildInputs = with py; [ wxPython ];

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
    homepage = https://www.christoph-sommer.de/loxodo/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

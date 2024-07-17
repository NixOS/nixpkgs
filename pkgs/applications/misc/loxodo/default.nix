{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "loxodo";
  version = "unstable-2021-02-08";

  src = fetchFromGitHub {
    owner = "sommer";
    repo = "loxodo";
    rev = "7add982135545817e9b3e2bbd0d27a2763866133";
    sha256 = "1cips4pvrqga8q1ibs23vjrf8dwan860x8jvjmc52h6qvvvv60yl";
  };

  patches = [ ./wxpython.patch ];

  propagatedBuildInputs = with python3.pkgs; [
    six
    wxpython
  ];

  postInstall = ''
    mv $out/bin/loxodo.py $out/bin/loxodo
    mkdir -p $out/share/applications
    cat > $out/share/applications/loxodo.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Exec=$out/bin/loxodo
    Icon=$out/${python3.sitePackages}/resources/loxodo-icon.png
    Name=Loxodo
    GenericName=Password Vault
    Categories=Application;Other;
    EOF
  '';

  doCheck = false; # Tests are interactive.

  meta = with lib; {
    description = "A Password Safe V3 compatible password vault";
    mainProgram = "loxodo";
    homepage = "https://www.christoph-sommer.de/loxodo/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}

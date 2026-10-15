{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "loxodo";
  version = "0-unstable-2021-02-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sommer";
    repo = "loxodo";
    rev = "7add982135545817e9b3e2bbd0d27a2763866133";
    hash = "sha256-1AOz997YQFFYlVuiDgyyijfkstxD6BUDRurhvC/RN7I=";
  };

  patches = [ ./wxpython.patch ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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

  meta = {
    description = "Password Safe V3 compatible password vault";
    mainProgram = "loxodo";
    homepage = "https://github.com/sommer/loxodo";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}

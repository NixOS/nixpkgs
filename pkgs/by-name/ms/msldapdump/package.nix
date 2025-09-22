{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "msldapdump";
  version = "0-unstable-2023-06-12";
  format = "other";

  src = fetchFromGitHub {
    owner = "dievus";
    repo = "msLDAPDump";
    rev = "bdffe66be20ff844f55f69fd6d842d7f75f66f2d";
    hash = "sha256-qH4AaebrTKYxxjXawllxgiG9fVm03zmTRv/HAyNpewg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    ldap3
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -vD msLDAPDump.py $out/bin/msLDAPDump.py

    makeWrapper ${python3.interpreter} $out/bin/msldapdump \
      --set PYTHONPATH "$PYTHONPATH:$out/bin/msLDAPDump.py" \
      --add-flags "-O $out/bin/msLDAPDump.py"

    runHook postInstall
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "LDAP enumeration tool";
    homepage = "https://github.com/dievus/msLDAPDump";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}

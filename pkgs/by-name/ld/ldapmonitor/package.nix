{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldapmonitor";
  version = "1.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "ldapmonitor";
    tag = version;
    hash = "sha256-BmTj/6dOUYfia6wO4nvkEW01MIC9TuBk4kYAsVHMsWY=";
  };

  sourceRoot = "${src.name}/python";

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
    python-ldap
  ];

  installPhase = ''
    runHook preInstall

    install -vD pyLDAPmonitor.py $out/bin/ldapmonitor

    runHook postInstall
  '';

  meta = {
    description = "Tool to monitor creation, deletion and changes to LDAP objects";
    mainProgram = "ldapmonitor";
    homepage = "https://github.com/p0dalirius/LDAPmonitor";
    changelog = "https://github.com/p0dalirius/LDAPmonitor/releases/tag/${version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}

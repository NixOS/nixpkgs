{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "silenthound";
  version = "0-unstable-2022-12-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "layer8secure";
    repo = "SilentHound";
    rev = "f04746aaca29e377c8badcbd6d8f6584deb9e919";
    hash = "sha256-alTgo8/aqwERt/JC4W3KodAdyfNZyG3XqCp3z4OpS68=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-ldap
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -vD $pname.py $out/bin/$pname

    runHook postInstall
  '';

  # Only script available
  doCheck = false;

  meta = with lib; {
    description = "Tool to enumerate an Active Directory Domain";
    homepage = "https://github.com/layer8secure/SilentHound";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "silenthound";
  };
}

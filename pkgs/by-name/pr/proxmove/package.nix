{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "proxmove";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ossobv";
    repo = "proxmove";
    rev = "v${version}";
    hash = "sha256-8xzsmQsogoMrdpf8+mVZRWPGQt9BO0dBT0aKt7ygUe4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    proxmoxer
  ];

  preBuild = ''
    rm -R assets
    rm -R artwork
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/${pname} --version

    runHook postCheck
  '';

  meta = with lib; {
    description = "Proxmox VM migrator: migrates VMs between different Proxmox VE clusters";
    mainProgram = "proxmove";
    homepage = "https://github.com/ossobv/proxmove";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ AngryAnt ];
  };
}

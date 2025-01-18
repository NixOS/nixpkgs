{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "powersploit";
  version = "3.0.0-unstable-2020-08-22";

  src = fetchFromGitHub {
    owner = "PowerShellMafia";
    repo = "PowerSploit";
    rev = "d943001a7defb5e0d1657085a77a0e78609be58f";
    hash = "sha256-xVMCB8siyYc8JI7vjlUdO93jI3Qh054F/4CCZyGe75c=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/windows/powersploit
    cp -a * $out/share/windows/powersploit
    find $out/share/windows -type f -exec chmod -x {} \;
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/PowerShellMafia/PowerSploit/releases/";
    description = "PowerShell Post-Exploitation Framework";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ shard7 ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}

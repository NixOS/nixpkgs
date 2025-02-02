{
  stdenvNoCC,
  fetchzip,
  lib,
  powershell,
  runtimeShell,
}:
stdenvNoCC.mkDerivation rec {
  pname = "powershell-editor-services";
  version = "4.2.0";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShellEditorServices/releases/download/v${version}/PowerShellEditorServices.zip";
    hash = "sha256-HSLpgnCx871BuKcerX8NZIN+NbpEz+KQtm1HfUXr7kY=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/lib/powershell-editor-services/ $out/bin
    mv * $out/lib/powershell-editor-services/
    cat > $out/bin/powershell-editor-services <<EOF
    #! ${runtimeShell} -e
    exec ${lib.getExe' powershell "pwsh"} -noprofile -nologo -c "& '$out/lib/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1' \$@"
    EOF
    chmod +x $out/bin/powershell-editor-services
  '';

  meta = with lib; {
    description = "Common platform for PowerShell development support in any editor or application";
    homepage = "https://github.com/PowerShell/PowerShellEditorServices";
    changelog = "https://github.com/PowerShell/PowerShellEditorServices/releases/tag/v${version}";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    mainProgram = "powershell-editor-services";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  perlPackages,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "regripper";
  version = "0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "keydet89";
    repo = "RegRipper3.0";
    rev = "89f3cac57e10bce1a79627e6038353e8e8a0c378";
    hash = "sha256-dW3Gr4HQH484i47Bg+CEnBYoGQQRMBJr88+YeuU+iV4=";
  };

  propagatedBuildInputs = [
    perl
    perlPackages.ParseWin32Registry
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    rm -r *.md *.exe *.bat *.dll

    cp -aR . "$out/share/regripper/"

    cat > "$out/bin/regripper" << EOF
    #!${runtimeShell}
    exec ${perl}/bin/perl $out/share/regripper/rip.pl "\$@"
    EOF

    chmod u+x  "$out/bin/regripper"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source forensic software used as a Windows Registry data extraction command line";
    mainProgram = "regripper";
    homepage = "https://github.com/keydet89/RegRipper3.0";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}

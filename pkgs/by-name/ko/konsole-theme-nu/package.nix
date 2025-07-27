{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "konsole-theme-nu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wvhulle";
    repo = "konsole-theme-nu";
    rev = "c58af51efca5fc0c39ae53bc6bd202a0813175cb";
    hash = "sha256-71FEdtavLny5o5YIF0d47U8ovdal8L3TK+XSfdORWj0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ nushell ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    # Install the nushell module
    mkdir -p $out/share/konsole-theme-nu
    cp mod.nu $out/share/konsole-theme-nu/

    # Create wrapper scripts for command-line usage
    mkdir -p $out/bin

    # Main script
    cat > $out/bin/konsole-theme-nu << EOF
#!/usr/bin/env bash
exec ${nushell}/bin/nu -c "use $out/share/konsole-theme-nu/mod.nu; mod set-konsole-profile '\$1'"
EOF
    chmod +x $out/bin/konsole-theme-nu

    # List profiles script
    cat > $out/bin/list-konsole-profiles << EOF
#!/usr/bin/env bash
exec ${nushell}/bin/nu -c "use $out/share/konsole-theme-nu/mod.nu; mod list-konsole-profiles"
EOF
    chmod +x $out/bin/list-konsole-profiles

    # Get current profile script
    cat > $out/bin/get-konsole-profile << EOF
#!/usr/bin/env bash
exec ${nushell}/bin/nu -c "use $out/share/konsole-theme-nu/mod.nu; mod get-konsole-profile"
EOF
    chmod +x $out/bin/get-konsole-profile

    runHook postInstall
  '';

  meta = {
    description = "A nushell package for switching Konsole color profiles";
    homepage = "https://github.com/wvhulle/konsole-theme-nu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wvhulle ];
    platforms = lib.platforms.linux;
    mainProgram = "konsole-theme-nu";
  };
}
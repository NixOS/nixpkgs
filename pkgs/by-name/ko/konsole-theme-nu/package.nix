{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  writers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "konsole-theme-nu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wvhulle";
    repo = "konsole-theme-nu";
    rev = "c58af51efca5fc0c39ae53bc6bd202a0813175cb";
    hash = "sha256-71FEdtavLny5o5YIF0d47U8ovdal8L3TK+XSfdORWj0=";
  };

  buildInputs = [ nushell ];

  installPhase = ''
    runHook preInstall

    # Install the Nu module
    install -Dm644 mod.nu $out/share/konsole-theme-nu/mod.nu

    # Create Nu script wrappers by copying and substituting path
    mkdir -p $out/bin

    cp ${writers.writeNuBin "konsole-theme-nu" ''use PLACEHOLDER/share/konsole-theme-nu/mod.nu; mod set-konsole-profile''}/bin/konsole-theme-nu $out/bin/konsole-theme-nu
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/konsole-theme-nu
    chmod +x $out/bin/konsole-theme-nu

    cp ${writers.writeNuBin "list-konsole-profiles" ''use PLACEHOLDER/share/konsole-theme-nu/mod.nu; mod list-konsole-profiles''}/bin/list-konsole-profiles $out/bin/list-konsole-profiles
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/list-konsole-profiles
    chmod +x $out/bin/list-konsole-profiles

    cp ${writers.writeNuBin "get-konsole-profile" ''use PLACEHOLDER/share/konsole-theme-nu/mod.nu; mod get-konsole-profile''}/bin/get-konsole-profile $out/bin/get-konsole-profile
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/get-konsole-profile
    chmod +x $out/bin/get-konsole-profile

    runHook postInstall
  '';

  meta = {
    description = "Nushell package for switching Konsole color profiles";
    homepage = "https://github.com/wvhulle/konsole-theme-nu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wvhulle ];
    platforms = lib.platforms.linux;
    mainProgram = "konsole-theme-nu";
  };
})

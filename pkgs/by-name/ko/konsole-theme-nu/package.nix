{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  writeShellScript,
}:

let
  pname = "konsole-theme-nu";
  version = "0.1.0";

  wrapperScripts = {
    konsole-theme-nu = writeShellScript "konsole-theme-nu" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod set-konsole-profile ''${1:-}"
    '';

    list-konsole-profiles = writeShellScript "list-konsole-profiles" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod list-konsole-profiles"
    '';

    get-konsole-profile = writeShellScript "get-konsole-profile" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod get-konsole-profile"
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

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

    # Create simple shell script wrappers
    install -Dm755 ${wrapperScripts.konsole-theme-nu} $out/bin/konsole-theme-nu
    install -Dm755 ${wrapperScripts.list-konsole-profiles} $out/bin/list-konsole-profiles
    install -Dm755 ${wrapperScripts.get-konsole-profile} $out/bin/get-konsole-profile

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

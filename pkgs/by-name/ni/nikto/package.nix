{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
  makeWrapper,
  installShellFiles,
}:

let
  version = "2.6.0";
in
stdenv.mkDerivation rec {
  pname = "nikto";
  inherit version;

  src = fetchFromGitHub {
    owner = "sullo";
    repo = "nikto";
    rev = version;
    sha256 = "sha256-iHOdMlfcKhvQCsCjWge6K+0h8kkgXa0Uii9o3YRQP5w=";
  };

  # Nikto searches its configuration file based on its current path
  # This fixes the current path regex for the wrapped executable.
  patches = [ ./nix-wrapper-fix.patch ];

  postPatch = ''
    # EXECDIR needs to be changed to the path where we copy the programs stuff
    # Forcing SSLeay is needed for SSL support (the auto mode doesn't seem to work otherwise)
    substituteInPlace program/nikto.conf.default \
      --replace-fail "# EXECDIR=/opt/nikto" "EXECDIR=$out/share" \
      --replace-fail "LW_SSL_ENGINE=auto" "LW_SSL_ENGINE=SSLeay"
    # Disable update check which prompts you to do a git pull and is not applicable for nixpkg
    substituteInPlace program/nikto.pl \
      --replace-fail "check_updates()" ""
  '';

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    perlPackages.perl
    perlPackages.NetSSLeay
    perlPackages.JSON
    perlPackages.XMLWriter
  ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share"
    cp -a program/* "$out/share"
    install -Dm 755 "program/nikto.pl" "$out/bin/nikto"
    install -Dm 644 program/nikto.conf.default "$out/etc/nikto.conf"
    installManPage documentation/nikto.1
    install -Dm 644 README.md "$out/share/doc/${pname}/README"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/nikto \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    description = "Web server scanner";
    mainProgram = "nikto";
    license = lib.licenses.gpl2Plus;
    homepage = "https://cirt.net/Nikto2";
    changelog = "https://github.com/sullo/nikto/releases/tag/${version}";
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nikto";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "sullo";
    repo = "nikto";
    tag = finalAttrs.version;
    hash = "sha256-jMbVJ35f1uPNQ7xmBnOhBMmh+u4Ewpd5GJFMg8ZKIxw=";
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
    install -Dm 644 README.md "$out/share/doc/${finalAttrs.pname}/README"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/nikto \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    description = "Web server scanner";
    homepage = "https://cirt.net/Nikto2";
    changelog = "https://github.com/sullo/nikto/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "nikto";
    platforms = lib.platforms.unix;
  };
})

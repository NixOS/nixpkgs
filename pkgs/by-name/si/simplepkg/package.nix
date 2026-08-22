{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix,
  git,
  sqlite,
  fish,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "simplepkg";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "void01n";
    repo = "simple-pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eYQ7szXFhI8azEz86OL3OjkLbdHtZgADRuZ1A+Gu6/E=";
  };
  dontBuild = true;
  dontConfigure = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fish/vendor_functions.d
    cp pkg.fish $out/share/fish/vendor_functions.d/
    cp pkg-import.fish $out/share/fish/vendor_functions.d/

    mkdir -p $out/bin
    cat > $out/bin/pkg <<'EOF'
#!/usr/bin/env bash
exec fish -c 'pkg $argv' -- "$@"
EOF
    chmod +x $out/bin/pkg
    wrapProgram $out/bin/pkg --prefix PATH : ${lib.makeBinPath [ fish ]}

    runHook postInstall
  '';
  propagatedBuildInputs = [
    nix
    git
    sqlite
  ];
  meta = {
    description = "Declarative-feeling pkg manager for NixOS packages.nix";
    homepage = "https://github.com/void01n/simple-pkg";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "pkg";
    maintainers = with lib.maintainers; [ void01n ];
  };
})

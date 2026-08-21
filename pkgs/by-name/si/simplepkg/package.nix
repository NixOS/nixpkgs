{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix,
  git,
  sqlite,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "simplepkg";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "void01n";
    repo = "simple-pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eYQ7szXFhI8azEz86OL3OjkLbdHtZgADRuZ1A+Gu6/E="; # nix build will report the correct value on first attempt
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fish/vendor_functions.d
    cp pkg.fish $out/share/fish/vendor_functions.d/
    cp pkg-import.fish $out/share/fish/vendor_functions.d/

    runHook postInstall
  '';

  propagatedBuildInputs = [
    nix
    git
    sqlite
  ];

  meta = {
    description = "Declarative-feeling pkg manager for NixOS packages.nix";
    homepage = "https://github.com/void01n/simplepkg";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "pkg";
    maintainers = with lib.maintainers; [ void01n ];
  };
})

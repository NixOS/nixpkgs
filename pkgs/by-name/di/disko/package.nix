{ stdenvNoCC
, makeWrapper
, lib
, fetchFromGitHub
, bash
, nix
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "disko";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "disko";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wOIJwAsnZhM0NlFRwYJRgO4Lldh8j9viyzwQXtrbNtM=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];
  installPhase = ''
    mkdir -p $out/bin $out/share/disko
    cp -r cli.nix default.nix disk-deactivate lib $out/share/disko
    sed -e "s|libexec_dir=\".*\"|libexec_dir=\"$out/share/disko\"|" disko > $out/bin/disko
    chmod 755 $out/bin/disko
    wrapProgram $out/bin/disko --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/disko --help
  '';
  meta = {
    homepage = "https://github.com/nix-community/disko";
    description = "Declarative disk partitioning and formatting using nix";
    license = lib.licenses.mit;
    mainProgram = "disko";
    maintainers = with lib.maintainers; [ mic92 lassulus ];
    platforms = lib.platforms.linux;
  };
})

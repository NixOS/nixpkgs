{ stdenvNoCC
, makeWrapper
, lib
, fetchFromGitHub
, bash
, nix
, nixos-install
, coreutils
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "disko";
  version = "1.8.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "disko";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5zShvCy9S4tuISFjNSjb+TWpPtORqPbRZ0XwbLbPLho=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/disko
    cp -r install-cli.nix cli.nix default.nix disk-deactivate lib $out/share/disko

    for i in disko disko-install; do
      sed -e "s|libexec_dir=\".*\"|libexec_dir=\"$out/share/disko\"|" "$i" > "$out/bin/$i"
      chmod 755 "$out/bin/$i"
      wrapProgram "$out/bin/$i" --prefix PATH : ${lib.makeBinPath [ nix coreutils nixos-install ]}
    done
    runHook postInstall
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/disko --help
    $out/bin/disko-install --help
    runHook postInstallCheck
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

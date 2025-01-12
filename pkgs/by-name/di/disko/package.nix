{
  stdenvNoCC,
  makeWrapper,
  lib,
  fetchFromGitHub,
  bash,
  nix,
  nixos-install,
  coreutils,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "disko";
  version = "1.10.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "disko";
    rev = "v${finalAttrs.version}";
    hash = "sha256-snPBgTqwn3FPZVdFC5yt7Bnk3squim1vZOZ8CObWykk=";
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
      wrapProgram "$out/bin/$i" \
        --set DISKO_VERSION "${finalAttrs.version}" \
        --prefix PATH : ${
          lib.makeBinPath [
            nix
            coreutils
            nixos-install
          ]
        }
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

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/nix-community/disko";
    description = "Declarative disk partitioning and formatting using nix";
    license = lib.licenses.mit;
    mainProgram = "disko";
    maintainers = with lib.maintainers; [
      mic92
      lassulus
      iFreilicht
    ];
    platforms = lib.platforms.linux;
  };
})

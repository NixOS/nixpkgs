{
  stdenvNoCC,
  makeWrapper,
  lib,
  fetchFromGitHub,
  bash,
  nix,
  nixos-install,
  coreutils,
  xcp,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "disko";
  version = "1.13.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "disko";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CNzzBsRhq7gg4BMBuTDObiWDH/rFYHEuDRVOwCcwXw4=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/disko
    cp -r install-cli.nix cli.nix default.nix disk-deactivate lib $out/share/disko

    scripts=(disko)
    ${lib.optionalString (!stdenvNoCC.isDarwin) ''
      scripts+=(disko-install)
    ''}

    for i in "''${scripts[@]}"; do
      sed -e "s|libexec_dir=\".*\"|libexec_dir=\"$out/share/disko\"|" "$i" > "$out/bin/$i"
      chmod 755 "$out/bin/$i"
      wrapProgram "$out/bin/$i" \
        --set DISKO_VERSION "${finalAttrs.version}" \
        --prefix PATH : ${
          lib.makeBinPath (
            [
              nix
              coreutils
              xcp
            ]
            ++ lib.optional (!stdenvNoCC.isDarwin) nixos-install
          )
        }
    done
    runHook postInstall
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/disko --help
    ${lib.optionalString (!stdenvNoCC.isDarwin) ''
      $out/bin/disko-install --help
    ''}
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
      Enzime
    ];
    platforms = lib.platforms.unix;
  };
})

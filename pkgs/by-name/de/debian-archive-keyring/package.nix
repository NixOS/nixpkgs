{
  lib,
  fetchFromGitLab,
  stdenvNoCC,
  nix-update-script,
  jetring,
  gnupg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "debian-archive-keyring";
  version = "2025.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "release-team";
    repo = "debian-archive-keyring";
    tag = finalAttrs.version;
    hash = "sha256-NaVbca1mx0j4hfSncX8hh8PbtB92yGeZUUdp4Nx9JoY=";
  };

  nativeBuildInputs = [
    jetring
    gnupg
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/share/keyrings/
    cp trusted.pgp/debian-archive-*.pgp $out/share/keyrings/
    cp -a trusted.pgp/debian-archive-*.gpg $out/share/keyrings/
    cp keyrings/debian-archive-keyring.pgp $out/share/keyrings/
    cp -a keyrings/debian-archive-keyring.gpg $out/share/keyrings/
    cp keyrings/debian-archive-removed-keys.pgp $out/share/keyrings/
    cp -a keyrings/debian-archive-removed-keys.gpg $out/share/keyrings/

    install -D -m 644 -t $out/etc/apt/trusted.gpg.d apt-trusted-asc/*.asc

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GnuPG archive keys of the Debian archive";
    homepage = "https://salsa.debian.org/release-team/debian-archive-keyring";
    license = [ lib.licenses.publicDomain ];
    platforms = lib.platforms.all;
    badPlatforms = [ "x86_64-freebsd" ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})

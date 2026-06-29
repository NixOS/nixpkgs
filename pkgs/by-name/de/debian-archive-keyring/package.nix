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

  makeFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    mv $out/usr/share $out/share
    rm -d $out/usr
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GnuPG archive keys of the Debian archive";
    homepage = "https://salsa.debian.org/release-team/debian-archive-keyring";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})

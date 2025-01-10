{ lib
, stdenv
, fetchFromGitLab
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "recoverdm";
  version = "0.20-8";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "pkg-security-team";
    repo = "recoverdm";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-1iW3Ug85ZLGpvG29N5zJt8oooSQGnLsr+8XIcp4aSSM=";
  };

  patches = let patch = name: "./debian/patches/${name}"; in [
    (patch "10_fix-makefile.patch")
    (patch "20_fix-typo-binary.patch")
    (patch "30-fix-BTS-mergebad-crash.patch")
    (patch "40_dev-c.patch")
    ./0001-darwin-build-fixes.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(DESTDIR)/usr/bin' $out/bin
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    installManPage recoverdm.1
  '';

  meta = with lib; {
    description = "Recover damaged CD DVD and disks with bad sectors";
    mainProgram = "recoverdm";
    homepage = "https://salsa.debian.org/pkg-security-team/recoverdm";
    changelog = "https://salsa.debian.org/pkg-security-team/recoverdm/-/blob/debian/master/debian/changelog";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl1Only;
  };
})

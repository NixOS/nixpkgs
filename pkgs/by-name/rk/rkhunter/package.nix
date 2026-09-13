{ lib
, stdenvNoCC
, fetchurl
, fetchpatch
, bash
, perl
, wget
#, unhide
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rkhunter";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/rkhunter/rkhunter/${finalAttrs.version}/rkhunter-${finalAttrs.version}.tar.gz";
    hash = "sha256-91CqPiL4ObY3oHNkdRDXqjrfdJbiHzyHW3o2jHHTdIc=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/d0297795fb3e3cd61af687ceb9fba7ff4b543237/debian/patches/01_use_bash.diff";
      hash = "sha256-TNpS4Dq370cIp8CvYIEsA21/Hc/nUzDFTdjzZI80pqg=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/b82f90ca1206983c161b27043dfa4e1cc330cb78/debian/patches/05_custom_conffile.diff";
      hash = "sha256-rIiuj2jWs4BDEw5Ida1lY4VSZB3D2sCfILmrZfnzVAY=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/b3243157bb4cffc705d941f9aac81255552c6cb5/debian/patches/06_disable-updates.diff";
      hash = "sha256-yV7Ft7Bc4MiJjKD+lziBP1L0VYWB5wFnFG7PIGlls1I=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/7cae8010457b61cb10f5f61e22a198636623f604/debian/patches/10_fix-man.diff";
      hash = "sha256-Bkhf+drthOsDd9uHedQp40jYa1EBnXL1E5qRZn0wbYE=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/3ee5b095486ca556784f89e46fcc3ee2b0e2b3fa/debian/patches/15_remove-empty-dir.diff";
      hash = "sha256-040Gb2KhS9wwBKKq+1R+Sts8oWgXsXxDG3FMy3Gknqw=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/11aa2ce95ea6bee345d7cba61fe8a600a9c839f6/debian/patches/30_fix-lang-update-grep.diff";
      hash = "sha256-fl1lvIkyJk1HEsOzejbZ7CCxRGxuH8w0iSXo4a5D1qY=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/0cc34c30af2706038b7f56f841102b646985c03a/debian/patches/50_remove_libkeyutils.diff";
      hash = "sha256-UrvBQW6BiMOt3FjfOZycxZ4EiuzWR9zdAZoWkw3JAhY=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/d0297795fb3e3cd61af687ceb9fba7ff4b543237/debian/patches/60_reorder_whitelist.diff";
      hash = "sha256-J25T5DVuN2B9xut+pb/ZkM3rQxZlbxbS9PuQbFItqvc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rkhunter/-/raw/d0297795fb3e3cd61af687ceb9fba7ff4b543237/debian/patches/61_egrep_text_option.diff";
      hash = "sha256-yG5rse2CYGt+iuPtMbXO+G7hkf3ZJ9QlrsT7n9TiMzU=";
    })
  ];

  buildInputs = [
    bash
    perl
    wget
  #  unhide
  ];

  postPatch = ''
    patchShebangs installer.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ./installer.sh --layout custom $out --striproot / --install
    runHook postInstall
  '';

  postInstall = ''
    rm -f "$out/var/lib/rkhunter/tmp/"{group,passwd}
  '';

  meta = with lib; {
    description = "Scan systems for known and unknown rootkits, backdoors, sniffers and exploits";
    homepage = "https://rkhunter.sourceforge.net/";
    license = licenses.gpl2Plus;
    mainProgram = "rkhunter";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})

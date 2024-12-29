{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dns2tcp";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "alex-sector";
    repo = "dns2tcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oBKkuQGVQNVzx8pds3qkZkZpwg8b44g1ovonrq2nqKw=";
  };

  patches = [
    # fixes gcc-10 build issues.
    (fetchpatch {
      url = "https://salsa.debian.org/debian/dns2tcp/-/raw/86b518ce169e88488d71c6b0270d4fc814dc1fbc/debian/patches/01_fix_gcc10_issues.patch.";
      hash = "sha256-IGpUIajkhruou7meZZJEJ5nnsQ/hVflyPfAuh3J0otI=";
    })
    # fixes some spelling errors.
    (fetchpatch {
      url = "https://salsa.debian.org/debian/dns2tcp/-/raw/13481f37b7184e52b83cc0c41edfc6b20a5debed/debian/patches/fix_spelling_errors.patch";
      hash = "sha256-b65olctlwLOY2GnVb7i7axGFiR0iLoTYstXdtVkU3vQ=";
    })
  ];

  meta = with lib; {
    description = "Tool for relaying TCP connections over DNS";
    homepage = "https://github.com/alex-sector/dns2tcp";
    license = licenses.gpl2Plus;
    mainProgram = "dns2tcpc";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})

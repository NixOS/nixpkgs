{ lib
, stdenv
, fetchurl
, autoreconfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "missidentify";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/missidentify/missidentify/missidentify-${finalAttrs.version}/missidentify-${finalAttrs.version}.tar.gz";
    hash = "sha256-nnIRN8hpKM0IZCe0HUrrJGrxvBYKeBmdU168rlo8op0=";
  };

  patches = [
    # define PATH_MAX variable to fix a FTBFS in Hurd.
    (fetchurl {
      name = "fix-FTBFS-Hurd.patch";
      url = "https://salsa.debian.org/pkg-security-team/missidentify/-/raw/14b7169c3157dbad65fc80fdd82ec6634df20ffd/debian/patches/fix-FTBFS-Hurd.patch";
      hash = "sha256-wGEzTfT76s5Q7s/5s913c4x9MMn9c0v/4Lhr+QakPQY=";
    })
    # fix a hyphen used as minus sign and a typo in manpage.
    (fetchurl {
      name = "fix-manpage.patch";
      url = "https://salsa.debian.org/pkg-security-team/missidentify/-/raw/14b7169c3157dbad65fc80fdd82ec6634df20ffd/debian/patches/fix-manpage.patch";
      hash = "sha256-7LzQs6ETRSjdnEhlKOVWC3grevwOmGs0h4Z6AYGysD8=";
    })
    # fix darwin build
    ./fix-darwin-build.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "--build=arm" ];

  meta = with lib; {
    description = "Find Win32 applications";
    longDescription = ''
      Miss Identify is a program to find Win32 applications. In
      its default mode it displays the filename of any executable
      that does not have an executable extension (i.e. exe, dll,
      com, sys, cpl, hxs, hxi, olb, rll, or tlb). The program can
      also be run to display all executables encountered,
      regardless of the extension. This is handy when looking
      for all of the executables on a drive. Other options allow
      the user to record the strings found in an executable and
      to work recursively.
    '';
    mainProgram = "missidentify";
    homepage = "https://missidentify.sourceforge.net";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Only;
  };
})

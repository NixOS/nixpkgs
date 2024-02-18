{ lib
, stdenv
, fetchzip
, fetchpatch
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rifiuti";
  version = "20040505_1";

  src = fetchzip {
    url = "mirror://sourceforge/project/odessa/Rifiuti/${finalAttrs.version}/rifiuti_${finalAttrs.version}.zip";
    hash = "sha256-bVPz0nXexGtQtXxGb3Mc79tzyZikc7KxNNWuvgu6pQ0=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/f237358a91b12776beb9942c79ccb3aea180968a/debian/patches/add-GCC-hardening";
      hash = "sha256-4cQSNtnHRD88TEP2iESgFlY16Y8WZZityIQh+M1kchQ=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/5b51604942b518b7752843cf7d693f202dc9c6f1/debian/patches/fix-bts-crash-on-malformed-file.patch";
      hash = "sha256-0XSNAvUyvPYsh0eipYYzxV87d9bz+uEpsOY1Y6PKO1w=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/f237358a91b12776beb9942c79ccb3aea180968a/debian/patches/fix-warnings";
      hash = "sha256-ZJ0937oYe+DkfSpW17iD390+VxLoF9txJI7qCqTBpfM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/5bd48acbcb63cee324556c4ec29750ce1e41755c/debian/patches/use-CC-and-abort-on-error.patch";
      hash = "sha256-aj1ubNMzzpBAyyEN/+zcdC0oC5eYBSDte7wR8isIyMw=";
    })
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace gcc cc
  '';

  makeFlags = [
    "-C src"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/rifiuti $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Analyze Windows Recycle Bin INFO2 file";
    mainProgram = "rifiuti";
    homepage = "https://sourceforge.net/projects/odessa/files/Rifiuti";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
})

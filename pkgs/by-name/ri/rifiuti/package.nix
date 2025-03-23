{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rifiuti";
  version = "20040505_1";

  src = fetchzip {
    url = "mirror://sourceforge/project/odessa/Rifiuti/${finalAttrs.version}/rifiuti_${finalAttrs.version}.zip";
    hash = "sha256-bVPz0nXexGtQtXxGb3Mc79tzyZikc7KxNNWuvgu6pQ0=";
  };

  patches = [
    (fetchurl {
      name = "add-GCC-hardening.patch";
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/f237358a91b12776beb9942c79ccb3aea180968a/debian/patches/add-GCC-hardening";
      hash = "sha256-Z4UajJ8WydoCKjkG4q7WsBSXWwkM8B6UXBoWN1Qas60=";
    })
    (fetchurl {
      name = "fix-bts-crash-on-malformed-file.patch";
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/5b51604942b518b7752843cf7d693f202dc9c6f1/debian/patches/fix-bts-crash-on-malformed-file.patch";
      hash = "sha256-1kZKC6qIGpCl1zOvKiWh6FcyYX3WozHBSPBHUsL2eMI=";
    })
    (fetchurl {
      name = "fix-warnings";
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/f237358a91b12776beb9942c79ccb3aea180968a/debian/patches/fix-warnings";
      hash = "sha256-9/OckpNqZQdkmNsUeHUEi6wT12mBd7aMA5dKgQAxXq8=";
    })
    (fetchurl {
      name = "use-CC-and-abort-on-error.patch";
      url = "https://salsa.debian.org/pkg-security-team/rifiuti/-/raw/5bd48acbcb63cee324556c4ec29750ce1e41755c/debian/patches/use-CC-and-abort-on-error.patch";
      hash = "sha256-RE4Vswtc887neJ3yAe0YWcs5YtZbwd1UtcTF4zBsmlo=";
    })
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail gcc cc
  '';

  makeFlags = [
    "-C src"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -D bin/rifiuti $out/bin/rifiuti
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

{ stdenv
, fetchFromGitHub
, unstableGitUpdater
, lib
}:
stdenv.mkDerivation {
  pname = "ps3iso-utils";
  version = "277db7de";

  src = fetchFromGitHub {
    owner = "bucanero";
    repo = "ps3iso-utils";
    rev = "878090980a9042c61901920fed1b034af215e8c7";
    hash = "sha256-HUx5BqHBvVMUHReuJL0RcyxXOnufSt1Zi/ieAlI2eoc=";
  };

  buildPhase = ''
    mkdir -p bin/
    find . -type f -name "*.c" -exec \
    sh -c 'OFILE=`basename "{}" ".c"` && $CC "{}" -o bin/"$OFILE"' \;
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Estwald's PS3ISO utilities";
    homepage = "https://github.com/bucanero/ps3iso-utils";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ soupglasses ];
    platforms = platforms.all;
  };
}


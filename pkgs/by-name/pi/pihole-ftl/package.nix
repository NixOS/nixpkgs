{ lib
, stdenv
, fetchFromGitHub
, cmake
, gmp
, libidn
, nettle
, readline
, ncurses
, xxd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pihole-ftl";
  version = "5.23";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "FTL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kMOGf6Qsayhr7uuFp9cGqJFubpFwlhJjVxEdpC1mO/M=";
  };

  patches = [
    ./0000-fix-readline-linking.patch
    # Nix enables fortification, avoid duplicating the compile definition
    ./0001-remove-fortify-source.patch
  ];

  nativeBuildInputs = [ cmake xxd ];

  buildInputs = [ gmp libidn nettle readline ncurses ];

  postPatch = [
    # Swap the static library suffix options to shared for non-static builds
    (lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      substituteInPlace src/CMakeLists.txt \
        --replace "CMAKE_STATIC_LIBRARY_SUFFIX" "CMAKE_SHARED_LIBRARY_SUFFIX"
    '')

    ''
      substituteInPlace src/version.h.in \
        --replace "@GIT_VERSION@" "v${finalAttrs.version}" \
        --replace "@GIT_DATE@" "1970-01-01" \
        --replace "@GIT_BRANCH@" "master" \
        --replace "@GIT_TAG@" "v${finalAttrs.version}" \
        --replace "@GIT_HASH@" "builtfromreleasetarball"
    ''
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp pihole-FTL $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pi-hole FTL engine";
    homepage = "https://github.com/pi-hole/FTL";
    license = licenses.eupl12;
    maintainers = with maintainers; [ williamvds ];
    platforms = platforms.linux;
    mainProgram = "pihole-FTL";
  };
})

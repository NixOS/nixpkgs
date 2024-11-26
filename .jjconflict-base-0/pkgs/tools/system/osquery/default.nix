{
  lib,
  cmake,
  fetchFromGitHub,
  fetchzip,
  fetchurl,
  git,
  perl,
  python3,
  stdenv,
  stdenvNoCC,
  ninja,
  nix-prefetch-git,
  autoPatchelfHook,
  jq,
  removeReferencesTo,
  nixosTests,
  writers,
}:

let

  info = builtins.fromJSON (builtins.readFile ./info.json);

  opensslSrc = fetchurl info.openssl;

  toolchain = import ./toolchain-bin.nix {
    inherit
      stdenv
      lib
      fetchzip
      autoPatchelfHook
      ;
  };

in

stdenvNoCC.mkDerivation rec {

  pname = "osquery";

  version = info.osquery.rev;

  src = fetchFromGitHub info.osquery;

  patches = [
    ./Remove-git-reset.patch
  ];

  nativeBuildInputs = [
    cmake
    git
    perl
    python3
    ninja
    autoPatchelfHook
    jq
    removeReferencesTo
  ];

  postPatch = ''
    substituteInPlace cmake/install_directives.cmake --replace "/control" "control"
  '';

  configurePhase = ''
    mkdir build
    cd build
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DOSQUERY_TOOLCHAIN_SYSROOT=${toolchain} \
      -DOSQUERY_VERSION=${version} \
      -DCMAKE_PREFIX_PATH=${toolchain}/usr/lib/cmake \
      -DCMAKE_LIBRARY_PATH=${toolchain}/usr/lib \
      -DOSQUERY_OPENSSL_ARCHIVE_PATH=${opensslSrc} \
      -GNinja
  '';

  disallowedReferences = [ toolchain ];

  postInstall = ''
    rm -rf $out/control
    remove-references-to -t ${toolchain} $out/bin/osqueryd
  '';

  passthru = {
    inherit opensslSrc toolchain;
    tests = {
      inherit (nixosTests) osquery;
    };
    updateScript = writers.writePython3 "osquery-update" {
      makeWrapperArgs = "--prefix PATH : ${lib.makeBinPath [ nix-prefetch-git ]}";
    } (builtins.readFile ./update.py);
  };

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = "https://osquery.io";
    license = with licenses; [
      gpl2Only
      asl20
    ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with maintainers; [
      znewman01
      lewo
      squalus
    ];
  };
}

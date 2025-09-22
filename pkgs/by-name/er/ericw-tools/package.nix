{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gtest,
  fmt,
  cmake,
  ninja,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "ericw-tools";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "ericwa";
    repo = "ericw-tools";
    rev = "v${version}";
    sha256 = "11sap7qv0rlhw8q25azvhgjcwiql3zam09q0gim3i04cg6fkh0vp";
  };
  postUnpack = ''
    pushd source/3rdparty
    ln -s ${fmt.src} fmt
    ln -s ${gtest.src} googletest
    popd
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/ericwa/ericw-tools/commit/c9570260fa895dde5a21272d76f9a3b05d59efdd.patch";
      hash = "sha256-dZr2LWuJBAIT//XHXYEz2vhaK2mxtxkSJ4IQla8OXKI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    installShellFiles
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for TOOL in bspinfo bsputil light qbsp vis ; do
      cp -a $TOOL/$TOOL $out/bin/
    done

    installManPage ../man/*.?

    mkdir -p $doc/share/doc/ericw-tools
    cp -a ../README.md ../changelog.txt $doc/share/doc/ericw-tools/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ericwa.github.io/ericw-tools/";
    description = "Map compile tools for Quake and Hexen 2";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.unix;
  };
}

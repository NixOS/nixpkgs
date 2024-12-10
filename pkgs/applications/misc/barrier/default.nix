{
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  xorg,
  avahi,
  qtbase,
  mkDerivation,
  openssl,
  wrapGAppsHook3,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; },
  fetchpatch,
}:

mkDerivation rec {
  pname = "barrier";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "debauchee";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2tHqLF3zS3C4UnOVIZfpcuzaemC9++nC7lXgFnFSfKU=";
    fetchSubmodules = true;
  };

  patches = [
    # This patch can be removed when a new version of barrier (greater than 2.4.0)
    # is released, which will contain this commit.
    (fetchpatch {
      name = "add-missing-cstddef-header.patch";
      url = "https://github.com/debauchee/barrier/commit/4b12265ae5d324b942698a3177e1d8b1749414d7.patch";
      sha256 = "sha256-ajMxP7szBFi4h8cMT3qswfa3k/QiJ1FGI3q9fkCFQQk=";
    })
  ];

  CXXFLAGS = [
    # error: 'uint8_t' is not a member of 'std'; did you mean 'wint_t'?
    "-include cstdint"
  ];

  buildInputs = [
    curl
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    avahiWithLibdnssdCompat
    qtbase
  ];
  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
  ];

  postFixup = ''
    substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=$out/bin/barrier"
  '';

  qtWrapperArgs = [
    ''--prefix PATH : ${lib.makeBinPath [ openssl ]}''
  ];

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Barrier is KVM software forked from Symless's synergy 1.9 codebase.
      Synergy was a commercialized reimplementation of the original
      CosmoSynergy written by Chris Schoeneman.
    '';
    homepage = "https://github.com/debauchee/barrier";
    downloadPage = "https://github.com/debauchee/barrier/releases";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.phryneas ];
    platforms = lib.platforms.linux;
    mainProgram = "barrier";
  };
}

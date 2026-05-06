{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  autoreconfHook,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filebench";
  version = "1.5-alpha3-unstable-2020-02-20";

  src = fetchFromGitHub {
    owner = "filebench";
    repo = "filebench";
    rev = "22620e602cbbebad90c0bd041896ebccf70dbf5f";
    hash = "sha256-IVQSEUZOC+X3C994tnk0n3NI7yu2yPAWlPA7zdSbvlg=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/filebench/filebench/commit/82191902e44b7a136adb9285bcce3d4a52551b9e.patch?full_index=1";
      hash = "sha256-Uf4DrHZl94m502C7MynMtYpon1886RLbXGKW6lYq1SI=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  meta = {
    description = "File system and storage benchmark that can generate both micro and macro workloads";
    homepage = "https://sourceforge.net/projects/filebench/";
    license = lib.licenses.cddl;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "filebench";
  };
})

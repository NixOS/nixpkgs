{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  uthash,
  meson,
  ninja,
  pkg-config,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdicom";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "libdicom";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9n0Gp9+fmTM/shgWC8zpwt1pic9BrvDubOt7f+ZDMeE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-24793.CVE-2024-24794.patch";
      url = "https://github.com/ImagingDataCommons/libdicom/commit/3661aa4cdbe9c39f67d38ae87520f9e3ed50ab16.patch";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-/KTp0nKYk6jX4phNHY+nzjEptUBHKM2JkOftS5vHsEw=";
    })
  ];

  buildInputs = [ uthash ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ] ++ lib.optionals (finalAttrs.finalPackage.doCheck) [ check ];

  mesonBuildType = "release";

  mesonFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-Dtests=false" ];

  doCheck = true;

  meta = with lib; {
    description = "C library for reading DICOM files";
    homepage = "https://github.com/ImagingDataCommons/libdicom";
    license = licenses.mit;
    maintainers = with maintainers; [ lromor ];
    platforms = platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  coreutils,
  git,
  zlib,
}:

let
  niimathTestsSrc = fetchFromGitHub {
    owner = "rordenlab";
    repo = "niimath_tests";
    rev = "e482edf54fb5bea6e08047ba731600d26925d493";
    hash = "sha256-FC9NHogt4Cmq7/9mao12LN7du9CoXVnonkwhafIpIQo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "niimath";
  version = "1.0.20240905";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "niimath";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-3XgB4q0HXLo9rEQBzC+2dxN81r9n8kkj2OC5d+WFmEs=";
  };

  postPatch = ''
    cp -r ${niimathTestsSrc} niimath_tests
    chmod -R +w niimath_tests
    patchShebangs niimath_tests/canonical_test.sh
  '';

  nativeBuildInputs = [
    cmake
    git
  ];

  buildInputs = [ zlib ];

  cmakeFlags = [ "-DZLIB_IMPLEMENTATION=System" ];

  doCheck = true;
  checkPhase = ''
    PATH=bin:$PATH ../niimath_tests/canonical_test.sh
  '';
  nativeCheckInputs = [ coreutils ];

  meta = {
    description = "Open-source clone of fslmaths";
    homepage = "https://github.com/rordenlab/niimath";
    changelog = "https://github.com/rordenlab/niimath/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "niimath";
    platforms = lib.platforms.all;
  };
})

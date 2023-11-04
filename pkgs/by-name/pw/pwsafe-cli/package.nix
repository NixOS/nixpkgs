{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, libX11
, libXmu
, withX11 ? true
, openssl
, testers
}:

let
  baseVersion = "0.2.2beta";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pwsafe-cli";
  version = baseVersion + "-unstable-2022-01-05";

  src = fetchFromGitHub {
    owner = "nsd20463";
    repo = "pwsafe";
    rev = "4bf61c5e7a5ce11cb30cd4cc4ce10291ee12ded9";
    hash = "sha256-SXYN1aHuLwOvvqTSGZgFeVrAFBCRwYd3qpcnsc/VcXw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals withX11 [
    libX11
    libXmu
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "${baseVersion}" "${finalAttrs.version}"
  '';

   doCheck = true;

   passthru.tests.version = testers.testVersion {
     package = finalAttrs.finalPackage;
   };

  meta = {
    description = "encrypted password database manager";
    homepage = "https://github.com/nsd20463/pwsafe";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pwsafe";
    maintainers = with lib.maintainers; [ robert-manchester ];
    platforms = lib.platforms.unix;
  };
})

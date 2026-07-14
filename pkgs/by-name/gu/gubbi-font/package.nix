{
  lib,
  stdenv,
  fetchFromGitHub,
  fontforge,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gubbi-font";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aravindavk";
    repo = "gubbi";
    tag = "v${finalAttrs.version}";
    sha256 = "10w9i3pmjvs1b3xclrgn4q5a95ss4ipldbxbqrys2dmfivx7i994";
  };

  nativeBuildInputs = [
    fontforge
    installFonts
  ];

  dontConfigure = true;

  preBuild = "patchShebangs generate.pe";

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Kannada font";
    maintainers = with lib.maintainers; [ pancaek ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})

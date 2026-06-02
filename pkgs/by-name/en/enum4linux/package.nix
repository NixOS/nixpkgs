{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  samba,
  perl,
  openldap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enum4linux";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "CiscoCXSecurity";
    repo = "enum4linux";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/R0P4Ft9Y0LZwKwhDGAe36UKviih6CNbJbj1lcNKEkM=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    openldap
    perl
    samba
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp enum4linux.pl $out/bin/enum4linux

    wrapProgram $out/bin/enum4linux \
      --prefix PATH : ${
        lib.makeBinPath [
          samba
          openldap
        ]
      }
  '';

  meta = {
    description = "Tool for enumerating information from Windows and Samba systems";
    mainProgram = "enum4linux";
    homepage = "https://labs.portcullis.co.uk/tools/enum4linux/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fishi0x01 ];
    platforms = lib.platforms.unix;
  };
})

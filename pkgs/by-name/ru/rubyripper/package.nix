{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  cdparanoia,
  cddiscid,
  ruby,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.8.0rc3";
  pname = "rubyripper";

  src = fetchFromGitHub {
    owner = "bleskodev";
    repo = "rubyripper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LjlQKSCGc85HMgGRYJQVTOpjU/Z7AdIGdP4m9hba3OE=";
  };

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-cli" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    cddiscid
    cdparanoia
    ruby
  ];

  postInstall = ''
    cp -r share $out/
  '';

  postFixup = ''
    wrapProgram $out/bin/rrip_cli \
      --prefix PATH : ${
        lib.makeBinPath [
          cddiscid
          cdparanoia
          ruby
        ]
      }
  '';

  meta = {
    description = "High quality CD audio ripper";
    mainProgram = "rrip_cli";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/bleskodev/rubyripper";
  };
})

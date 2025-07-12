{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  cdparanoia,
  cddiscid,
  ruby,
}:

stdenv.mkDerivation rec {
  version = "0.8.0rc3";
  pname = "rubyripper";

  src = fetchFromGitHub {
    owner = "bleskodev";
    repo = "rubyripper";
    rev = "v${version}";
    sha256 = "1qfwv8bgc9pyfh3d40bvyr9n7sjc2na61481693wwww640lm0f9f";
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

  meta = with lib; {
    description = "High quality CD audio ripper";
    mainProgram = "rrip_cli";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    homepage = "https://github.com/bleskodev/rubyripper";
  };
}

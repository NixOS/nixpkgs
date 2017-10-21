{lib, trivialBuild, fetchFromGitHub}:

trivialBuild rec {
  pname    = "nyan-mode";
  version  = "20150128";

  src = fetchFromGitHub {
    owner  = "TeMPOraL";
    repo   = pname;
    rev    = "41faa2c809da7b2cb3e6f8fadefae3f338ced3f2";
    sha256 = "1idaac7sjc8hhbf5zif61ncg1pvg28c0qfihavdx61albww0ll7f";
  };

  patches = [ ./directory.patch ];

  preBuild = ''
    substituteInPlace nyan-mode.el \
      --replace "@OUT@" "$out/"
  '';

  postInstall = ''
    cp -r img $out
    cp -r mus $out
  '';

  meta = {
    description = "An analog indicator of the position in the buffer";
    license = lib.licenses.gpl3Plus;
  };
}

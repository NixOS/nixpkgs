{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hr";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "LuRsT";
    repo = "hr";
    rev = version;
    sha256 = "sha256-Pcnkiq7ipLoz6MFWZkCIxneUuZ3w/d+iqiyTz55WZvs=";
  };

  dontBuild = true;
  installFlags = [
    "PREFIX=$(out)"
    "MANPREFIX=$(out)/share"
  ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  meta = with lib; {
    homepage = "https://github.com/LuRsT/hr";
    description = "A horizontal bar for your terminal";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
    mainProgram = "hr";
  };
}

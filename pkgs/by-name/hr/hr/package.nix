{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hr";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "LuRsT";
    repo = "hr";
    rev = version;
    sha256 = "sha256-05num4v8C3n+uieKQJVLOzu9OOMBsUMPqq08Ou6gmYQ=";
  };

  dontBuild = true;
  installFlags = [
    "PREFIX=$(out)"
    "MANPREFIX=$(out)/share"
  ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/LuRsT/hr";
    description = "Horizontal bar for your terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://github.com/LuRsT/hr";
    description = "Horizontal bar for your terminal";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hr";
  };
}

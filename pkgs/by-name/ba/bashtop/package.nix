{
  stdenv,
  lib,
  fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "bashtop";
  version = "0.9.25";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = "bashtop";
    rev = "v0.9.25";
    hash = "sha256-ewR1Z9z6GQfSFknTaqhsk8NKiSDXBdkVjP4sX7fJ1B4=";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/aristocratos/bashtop";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.tretinha ];
  };
}

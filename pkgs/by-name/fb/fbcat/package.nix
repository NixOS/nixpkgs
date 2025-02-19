{
  lib,
  stdenv,
  fetchFromGitHub,
  netpbm,
}:

stdenv.mkDerivation rec {
  pname = "fbcat";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = pname;
    rev = version;
    sha256 = "sha256-ORzcd8XGy2BfwuPK5UX+K5Z+FYkb+tdg/gHl3zHjvbk=";
  };

  postPatch = ''
    substituteInPlace fbgrab \
      --replace 'pnmtopng' '${netpbm}/bin/pnmtopng' \
      --replace 'fbcat' "$out/bin/fbcat"
  '';

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "http://jwilk.net/software/fbcat";
    description = "Framebuffer screenshot tool";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  makeWrapper,
  procps,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "ratpoison-sloppymove";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cactus-d";
    repo = "ratpoison-sloppymove";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l+RCOdeLAW8tg+pZDFDNpqq3pBZrf8clhnNemHjsYtc=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libx11
  ];

  outputs = [
    "out"
  ];

  strictDeps = true;

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/ratpoison-sloppymove \
      --prefix PATH : "${lib.makeBinPath [ procps ]}:$out/bin"
  '';

  meta = {
    homepage = "https://github.com/cactus-d/ratpoison-sloppymove";
    description = "Improved version of sloppy focus for Ratpoison that allows for keyboard frame switches when the rat is not in motion";
    longDescription = ''
      A companion program to ratpoison (https://www.nongnu.org/ratpoison/) which causes the frame focus to follow the mouse movement

      An improvement on the original "Sloppy Focus" packaged with ratpoison

      Implements a compromise between "rat" and "no rat" -- changes focus based on rat movement but still allows for keyboard-based focus changes too, which the original Sloppy Focus inhibited

      Based on the original Sloppy Focus by Shawn Betts sabetts@vcn.bc.ca GNU General Public License
    '';
    license = lib.licenses.gpl3;
    mainProgram = "ratpoison-sloppymove";
    maintainers = [ lib.maintainers.turtley12 ];
  };
})

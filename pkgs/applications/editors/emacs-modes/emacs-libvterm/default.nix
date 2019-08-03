{ stdenv, fetchFromGitHub, cmake, emacs, libvterm-neovim }:

let
  emacsSources = stdenv.mkDerivation {
    name = emacs.name + "-sources";
    src = emacs.src;

    dontConfigure = true;
    dontBuild = true;
    doCheck = false;
    fixupPhase = ":";

    installPhase = ''
      mkdir -p $out
      cp -a * $out
    '';

  };

  libvterm = libvterm-neovim.overrideAttrs(old: rec {
    pname = "libvterm-neovim";
    version = "2019-04-27";
    name = pname + "-" + version;
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "libvterm";
      rev = "89675ffdda615ffc3f29d1c47a933f4f44183364";
      sha256 = "0l9ixbj516vl41v78fi302ws655xawl7s94gmx1kb3fmfgamqisy";
    };
  });


in stdenv.mkDerivation rec {
  name = "emacs-libvterm-${version}";
  version = "unstable-2019-07-22";

  src = fetchFromGitHub {
    owner = "akermu";
    repo = "emacs-libvterm";
    rev = "301fe9fdfd5fb2496c8428a11e0812fd8a4c0820";
    sha256 = "0i1hn5gcxayqcbjrnpgczvbicq2vsyn59646ary3crs0mz9wlbpr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ emacs libvterm ];

  cmakeFlags = [
    "-DEMACS_SOURCE=${emacsSources}"
    "-DUSE_SYSTEM_LIBVTERM=True"
  ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install ../*.el $out/share/emacs/site-lisp
    install ../*.so $out/share/emacs/site-lisp
  '';
}

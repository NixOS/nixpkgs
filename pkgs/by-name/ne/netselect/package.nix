{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "netselect";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = "netselect";
    rev = "${pname}-${version}";
    hash = "sha256-fRJONe51rMLcbVYk7zCvSUMve2igsPN3WzJT+uX2zP4=";
  };

  postPatch = ''
    substituteInPlace netselect-apt \
      --replace "/usr/bin/" ""
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin netselect netselect-apt
    install -Dm444 -t $out/share/man/man1 *.1
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/apenwarr/netselect";
    description = "Ultrafast intelligent parallelizing binary-search implementation of \"ping\"";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}

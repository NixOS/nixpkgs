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
    sha256 = "1zncyvjzllrjbdvz7c50d1xjyhs9mwqfy92ndpfc5b3mxqslw4kx";
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

  meta = with lib; {
    homepage = "https://github.com/apenwarr/netselect";
    description = "Ultrafast intelligent parallelizing binary-search implementation of \"ping\"";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

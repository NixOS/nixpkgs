{
  lib,
  stdenv,
  fetchFromGitHub,
  libsodium,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "quicktun";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "UCIS";
    repo = "QuickTun";
    rev = "2d0c6a9cda8c21f921a5d1197aeee92e9568ca39";
    sha256 = "1ydvwasj84qljfbzh6lmhyzjc20yw24a0v2mykp8afsm97zzlqgx";
  };

  patches = [ ./tar-1.30.diff ]; # quicktun master seems not to need this

  buildInputs = [ libsodium ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace "cc=\"cc\"" "cc=\"$CC\""
  '';

  buildPhase = ''
    runHook preBuild
    bash build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    rm out/quicktun*tgz
    install -vD out/quicktun* -t $out/bin
    runHook postInstall
  '';

  passthru.tests.quicktun = nixosTests.quicktun;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Very simple, yet secure VPN software";
    homepage = "http://wiki.ucis.nl/QuickTun";
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}

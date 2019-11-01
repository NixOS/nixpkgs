{ stdenv
, lib
, fetchFromGitHub
, alex
, happy
, Agda
, buildPlatform
, buildPackages
, ghcWithPackages
}:

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "cedille";

  src = fetchFromGitHub {
    owner = "cedille";
    repo = "cedille";
    rev = "v${version}";
    sha256 = "16pc72wz6kclq9yv2r8hx85mkp0s125h12snrhcjxkbl41xx2ynb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ alex happy ];
  buildInputs = [ Agda (ghcWithPackages (ps: [ps.ieee])) ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE =
    lib.optionalString (buildPlatform.libc == "glibc")
      "${buildPackages.glibcLocales}/lib/locale/locale-archive";

  postPatch = ''
    patchShebangs create-libraries.sh
  '';

  installPhase = ''
    install -Dm755 -t $out/bin/ cedille
    install -Dm755 -t $out/bin/ core/cedille-core
    install -Dm644 -t $out/share/info docs/info/cedille-info-main.info

    mkdir -p $out/lib/
    cp -r lib/ $out/lib/cedille/
  '';

  meta = with stdenv.lib; {
    description = "An interactive theorem-prover and dependently typed programming language, based on extrinsic (aka Curry-style) type theory";
    homepage = https://cedille.github.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam mpickering ];
    platforms = platforms.unix;
  };
}

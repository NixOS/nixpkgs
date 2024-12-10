{
  stdenv,
  lib,
  fetchFromGitHub,
  alex,
  happy,
  Agda,
  buildPackages,
  ghcWithPackages,
}:

stdenv.mkDerivation rec {
  version = "1.1.2";
  pname = "cedille";

  src = fetchFromGitHub {
    owner = "cedille";
    repo = "cedille";
    rev = "v${version}";
    sha256 = "1j745q9sd32fhcb96wjq6xvyqq1k6imppjnya6x0n99fyfnqzvg9";
    fetchSubmodules = true;
  };

  patches = [
    ./Fix-to-string.agda-to-compile-with-Agda-2.6.1.patch
  ];

  nativeBuildInputs = [
    alex
    happy
  ];
  buildInputs = [
    Agda
    (ghcWithPackages (ps: [ ps.ieee ]))
  ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = lib.optionalString (
    stdenv.buildPlatform.libc == "glibc"
  ) "${buildPackages.glibcLocales}/lib/locale/locale-archive";

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

  meta = with lib; {
    description = "An interactive theorem-prover and dependently typed programming language, based on extrinsic (aka Curry-style) type theory";
    homepage = "https://cedille.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ mpickering ];
    platforms = platforms.unix;

    # Broken due to Agda update.  See
    # https://github.com/NixOS/nixpkgs/pull/129606#issuecomment-881107449.
    broken = true;
    hydraPlatforms = platforms.none;
  };
}

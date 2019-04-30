{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, texinfo
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
    sha256 = "17j7an5bharc8q1pj06615zmflipjdd0clf67cnfdhsmqwzf6l9r";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ texinfo alex happy ];
  buildInputs = [ Agda (ghcWithPackages (ps: [ps.ieee])) ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE =
    lib.optionalString (buildPlatform.libc == "glibc")
      "${buildPackages.glibcLocales}/lib/locale/locale-archive";

  patches = [
    # texinfo direntry fix. See: https://github.com/cedille/cedille/pull/86
    (fetchpatch {
      url = "https://github.com/cedille/cedille/commit/c058f42179a635c7b6179772c30f0eba4ac53724.patch";
      sha256 = "02qd86k5bdrygjzh2k0j0q5qk4nk2vwnsz7nvlssvysbvsmiba7x";
    })
  ];

  postPatch = ''
    patchShebangs create-libraries.sh
    patchShebangs docs/src/compile-docs.sh
  '';

  # We regenerate the info file in order to fix the direntry
  preBuild = ''
    rm -f docs/info/cedille-info-main.info
  '';

  buildFlags = [ "all" "cedille-docs" ];

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

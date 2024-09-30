{ lib
, stdenv
, fetchurl
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "quickjs";
  version = "2024-01-13";

  src = fetchurl {
    url = "https://bellard.org/quickjs/quickjs-${version}.tar.xz";
    hash = "sha256-PEv4+JW/pUvrSGyNEhgRJ3Hs/FrDvhA2hR70FWghLgM=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace "CONFIG_LTO=y" ""
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    texinfo
  ];

  postBuild = ''
    (cd doc
     makeinfo *texi)
  '';

  postInstall = ''
    (cd doc
     install -Dt $out/share/doc *texi *info)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    PATH="$out/bin:$PATH"

    # Programs exit with code 1 when testing help, so grep for a string
    set +o pipefail
    qjs     --help 2>&1 | grep "QuickJS version"
    qjscalc --help 2>&1 | grep "QuickJS version"
    set -o pipefail

    temp=$(mktemp).js
    echo "console.log('Output from compiled program');" > "$temp"
    set -o verbose
    out=$(mktemp) && qjsc         -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
    out=$(mktemp) && qjsc   -flto -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
  '';

  meta = with lib; {
    description = "Small and embeddable Javascript engine";
    homepage = "https://bellard.org/quickjs/";
    maintainers = with maintainers; [ stesie AndersonTorres ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "qjs";
  };
}

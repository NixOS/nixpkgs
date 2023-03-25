{ lib
, stdenv
, fetchurl
, zlib
, enableUnfree ? false
}:

stdenv.mkDerivation rec {
  pname = "glucose" + lib.optionalString enableUnfree "-syrup";
  version = "4.1";

  src = fetchurl {
    url = "http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup-${version}.tgz";
    hash = "sha256-Uaoc8b7SsU8VQ7CZ6FpW3RqSvjfm4+sMSh/Yg9XMUCk=";
  };

  sourceRoot = "glucose-syrup-${version}/${if enableUnfree then "parallel" else "simp"}";

  postPatch = ''
    substituteInPlace Main.cc \
      --replace "defined(__linux__)" "defined(__linux__) && defined(__x86_64__)"
  '';

  buildInputs = [ zlib ];

  makeFlags = [ "r" ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 ${pname}_release $out/bin/${pname}
    mkdir -p "$out/share/doc/${pname}-${version}/"
    install -Dm0755 ../{LICEN?E,README*,Changelog*} "$out/share/doc/${pname}-${version}/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern, parallel SAT solver (${if enableUnfree then "parallel" else "sequential"} version)";
    homepage = "https://www.labri.fr/perso/lsimon/research/glucose/";
    license = if enableUnfree then licenses.unfreeRedistributable else licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}

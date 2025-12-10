{
  stdenv,
  coreutils,
  lib,
  fetchFromGitea,
  makeWrapper,
}:
stdenv.mkDerivation {

  pname = "edname";
  version = "1.0.1";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitea {
    domain = "git.tudbut.de";
    owner = "TudbuT";
    repo = "edname";
    rev = "v1.0.1";
    hash = "sha256-Bj7c18O+Z64KlpTNG3FvR17YM2GsTOUyFuapUyhgZ6M=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp edname.sh "$out/bin/edname"
    wrapProgram "$out/bin/edname" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
        ]
      }"
  '';

  meta = {
    description = "Mass renamer using $EDITOR";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tudbut ];
    homepage = "https://git.tudbut.de/TudbuT/edname";
    mainProgram = "edname";
  };
}

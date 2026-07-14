{
  stdenv,
  coreutils,
  findutils,
  gnused,
  lib,
  fetchFromGitea,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "edname";
  version = "1.0.2";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitea {
    domain = "git.tudbut.de";
    owner = "TudbuT";
    repo = "edname";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8aT/xwdx/ORyCFfOu4LZuxUiErZ9ZiCdhJ/WKAiQwe0=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp edname.sh "$out/bin/edname"
    wrapProgram "$out/bin/edname" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnused
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
})

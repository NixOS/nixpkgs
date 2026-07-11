{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  theme ? "black",
}:

assert lib.asserts.assertOneOf "theme" theme [
  "black"
  "white"
];

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruppled-${theme}-cursors";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "gruppled-cursors";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ejlgdogjIYevZvB23si6bEeU6qY7rWXflaUyVk5MzqU=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/gruppled_${theme}
    cp -r gruppled_${theme}/{cursors,index.theme} $out/share/icons/gruppled_${theme}
  '';

  meta = {
    description = "Gruppled ${lib.toSentenceCase theme} Cursors theme";
    homepage = "https://github.com/nim65s/gruppled-cursors";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
